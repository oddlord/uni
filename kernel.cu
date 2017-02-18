
#include "cuda_runtime.h"
#include "cuda_runtime_api.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#include "Image.h"
#include "PPM.h"

#include <cstdio>
#include <cassert>
#include <iostream>

#define _USE_MATH_DEFINES
#include <math.h>
#include <iomanip>

static void CheckCudaErrorAux(const char *, unsigned, const char *,
	cudaError_t);
#define CUDA_CHECK_RETURN(value) CheckCudaErrorAux(__FILE__,__LINE__, #value, value)

/**
* Check the return value of the CUDA runtime API call and exit
* the application if the call has failed.
*/
static void CheckCudaErrorAux(const char *file, unsigned line,
	const char *statement, cudaError_t err) {
	if (err == cudaSuccess)
		return;
	std::cerr << statement << " returned " << cudaGetErrorString(err) << "("
		<< err << ") at " << file << ":" << line << std::endl;
	exit(1);
}

// useful defines
#define TILE_WIDTH 16
#define w (TILE_WIDTH + Mask_width - 1)
#define clamp(x) (min(max((x), 0.0), 1.0))

//Global variables
const int maskRows = 5;
const int maskColumns = 5;
const int maskRowsRadius = maskRows / 2;
const int maskColumnsRadius = maskColumns / 2;
__constant__ float deviceMaskData[maskRows * maskColumns];


__global__ void convolution(float *I, float *P,
	int channels, int width, int height) {

	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int depth = threadIdx.z;

	//Copia dato nella shared memory (Tiling)

	//Sincronizzati in atttedsa deglim altri
	__syncthreads();

	if (col < width && row < height && depth < channels) {
		//Evaluate convolution
		float pValue = 0;

		int startRow = row - maskRowsRadius;
		int startCol = col - maskColumnsRadius;

		for (int i = 0; i < maskRows; i++) {
			for (int j = 0; j < maskColumns; j++) {
				int currentRow = startRow + i;
				int currentColumn = startCol + j;

				pValue += I[(currentRow * width +  currentColumn) * channels + depth] * deviceMaskData[i * maskRows + j];
			}
		}

		//Salva il risultato dal registro alla global
		P[(row * width + col) * channels + depth] = pValue;
	}
}

// simple test to read/write PPM images, and process Image_t data
void test_images() {
	Image_t* inputImg = PPM_import("computer_programming.ppm");
	for (int i = 0; i < 300; i++) {
		Image_setPixel(inputImg, i, 100, 0, float(i) / 300);
		Image_setPixel(inputImg, i, 100, 1, float(i) / 300);
		Image_setPixel(inputImg, i, 100, 2, float(i) / 200);
	}
	PPM_export("test_output.ppm", inputImg);
	Image_t* newImg = PPM_import("test_output.ppm");
	inputImg = PPM_import("computer_programming.ppm");
	if (Image_is_same(inputImg, newImg))
		printf("Img uguali\n");
	else
		printf("Img diverse\n");
}

void constantFilter(float mask[])
{
	for (int x = 0; x < 5; x++)
	{
		for (int y = 0; y < 5; y++)
		{
			mask[x*5 + y] = (float)1 / (float)(5*5);
		}
	}
}

void identityFilter(float mask[])
{
	for (int x = 0; x < 5; x++)
	{
		for (int y = 0; y < 5; y++)
		{
			mask[x*5 + y] = 0;
		}
	}
	mask[2*5 + 2] = 1;
}

void gaussianFilter(float mask[])
{
	// means on X and Y are fixed to 0
	// correlation coefficient is fixed to 0
	// standard deviation is set to 1 (for both X and Y)
	float sigma = 1.0;
	float r, s = 2.0 * sigma * sigma;

	// sum is for normalization
	float sum = 0.0;

	// generate 5x5 mask values
	for (int x = -2; x <= 2; x++)
	{
		for (int y = -2; y <= 2; y++)
		{
			r = sqrt(x*x + y*y);
			mask[(x + 2)*5 + (y + 2)] = (exp(-(r*r) / s)) / (M_PI * s);
			sum += mask[(x + 2) * 5 + (y + 2)];
		}
	}

	// normalize the mask
	for (int i = 0; i < 5; ++i)
		for (int j = 0; j < 5; ++j)
			mask[i*5 + j] /= sum;

}

void printFilter(float mask[]) {
	for (int i = 0; i < 5; ++i)
	{
		for (int j = 0; j < 5; ++j)
			std::cout << mask[i*5 + j] << "\t";
		std::cout << std::endl;
	}
	std::cin.ignore();
}

int main() {

	int imageChannels;
	int imageWidth;
	int imageHeight;
	Image_t* inputImage;
	Image_t* outputImage;
	float *hostInputImageData;
	float *hostOutputImageData;
	float *deviceInputImageData;
	float *deviceOutputImageData;
	
	float hostMaskData[maskRows * maskColumns];
	gaussianFilter(hostMaskData);
	//printFilter(hostMaskData); // uncomment to check mask values

	inputImage = PPM_import("computer_programming.ppm");

	assert(maskRows == 5); /* mask height is fixed to 5 in this exercise */
	assert(maskColumns == 5); /* mask width is fixed to 5 in this exercise */

	imageWidth = Image_getWidth(inputImage);
	imageHeight = Image_getHeight(inputImage);
	imageChannels = Image_getChannels(inputImage);

	outputImage = Image_new(imageWidth, imageHeight, imageChannels);

	hostInputImageData = Image_getData(inputImage);
	hostOutputImageData = Image_getData(outputImage);

	// Allocate device buffers
	CUDA_CHECK_RETURN(
		cudaMalloc((void **)&deviceInputImageData,
			sizeof(float) * imageWidth * imageHeight * imageChannels));

	CUDA_CHECK_RETURN(
		cudaMalloc((void **)&deviceOutputImageData,
			sizeof(float) * imageWidth * imageHeight * imageChannels));


	//copy memory from host to device
	CUDA_CHECK_RETURN(
		cudaMemcpyToSymbol(deviceMaskData, hostMaskData, maskRows * maskColumns * sizeof(float)));
	CUDA_CHECK_RETURN(
		cudaMemcpy(deviceInputImageData, hostInputImageData, sizeof(float) * imageWidth * imageHeight * imageChannels,
			cudaMemcpyHostToDevice));

	//Evaluate block and thread number
	int requiredThread = (imageWidth + (maskColumnsRadius * 2)) * (imageHeight + (maskRowsRadius * 2)) * imageChannels;
	int numberThreadX = 16;
	int numberThreadY = 16;

	int numberBlockX = ceil((float)imageWidth /numberThreadX);
	int numberBlockY = ceil((float)imageHeight / numberThreadY);
		
	dim3 dimGrid(numberBlockX, numberBlockY); 
	dim3 dimBlock(numberThreadX, numberThreadY, 3); 
	convolution<<<dimGrid, dimBlock>>>(deviceInputImageData,
	 deviceOutputImageData, imageChannels, imageWidth, imageHeight);

	// Copy from device to host memory
	CUDA_CHECK_RETURN(
		cudaMemcpy(hostOutputImageData, deviceOutputImageData, sizeof(float) * imageWidth * imageHeight * imageChannels,
			cudaMemcpyDeviceToHost));

	PPM_export("processed_computer_programming.ppm", outputImage);

	// Free device memory
	//deviceMaskData memory doesn't need to be freed since it's a global variable
	cudaFree(deviceInputImageData);
	cudaFree(deviceOutputImageData);

	Image_delete(outputImage);
	Image_delete(inputImage);

	return 0;
}


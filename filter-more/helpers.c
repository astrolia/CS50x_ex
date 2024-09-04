#include "helpers.h"
#include <math.h>
#include <stdio.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    int i, j;
    int average = 0;

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            int rgbt =
                round((image[i][j].rgbtBlue + image[i][j].rgbtGreen + image[i][j].rgbtRed) / 3.0);
            image[i][j].rgbtBlue = image[i][j].rgbtGreen = image[i][j].rgbtRed = rgbt;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    RGBTRIPLE aux[height][width];
    int i, j;

    for (i = 0; i < height; i++)
    {
        if (width % 2 == 0)
        {

            for (j = 0; j < width / 2; j++)
            {
                aux[i][j] = image[i][j];
                image[i][j] = image[i][width - (j + 1)];
                image[i][width - (j + 1)] = aux[i][j];
            }
        }

        else
        {
            for (j = 0; j <= width / 2; j++)
            {
                aux[i][j] = image[i][j];
                image[i][j] = image[i][width - (j + 1)];
                image[i][width - (j + 1)] = aux[i][j];
            }
        }
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    float averageRed, averageGreen, averageBlue, count;
    int x, y, i, j;

    RGBTRIPLE aux[height][width];

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {

            averageRed = 0;
            averageGreen = 0;
            averageBlue = 0;
            count = 0;

            for (x = -1; x < 2; x++)
            {
                for (y = -1; y < 2; y++)
                {
                    if ((i + x) < 0 || (i + x) > height - 1)
                    {
                        continue;
                    }

                    if ((j + y) < 0 || (j + y) > width - 1)
                    {
                        continue;
                    }

                    averageRed += image[i + x][j + y].rgbtRed;
                    averageGreen += image[i + x][j + y].rgbtGreen;
                    averageBlue += image[i + x][j + y].rgbtBlue;
                    count++;
                }
            }

            aux[i][j].rgbtRed = round(averageRed / count);
            aux[i][j].rgbtGreen = round(averageGreen / count);
            aux[i][j].rgbtBlue = round(averageBlue / count);
        }
    }

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            image[i][j].rgbtRed = aux[i][j].rgbtRed;
            image[i][j].rgbtGreen = aux[i][j].rgbtGreen;
            image[i][j].rgbtBlue = aux[i][j].rgbtBlue;
        }
    }
    return;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    int Gx[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};

    int Gy[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};

    int x, y, i, j, f;
    int Gx_v[3] = {0, 0, 0};
    int Gy_v[3] = {0, 0, 0};
    int Gxy[3] = {0, 0, 0};

    RGBTRIPLE aux[height][width];

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            for (f = 0; f < 3; f++)
            {
                Gx_v[f] = 0;
                Gy_v[f] = 0;
                Gxy[f] = 0;
            }

            for (x = -1; x < 2; x++)
            {
                for (y = -1; y < 2; y++)
                {
                    if ((i + x) < 0 || (i + x) > height - 1)
                    {
                        continue;
                    }

                    if ((j + y) < 0 || (j + y) > width - 1)
                    {
                        continue;
                    }

                    Gx_v[0] += image[i + x][j + y].rgbtRed * Gx[x + 1][y + 1];
                    Gx_v[1] += image[i + x][j + y].rgbtGreen * Gx[x + 1][y + 1];
                    Gx_v[2] += image[i + x][j + y].rgbtBlue * Gx[x + 1][y + 1];

                    Gy_v[0] += image[i + x][j + y].rgbtRed * Gy[x + 1][y + 1];
                    Gy_v[1] += image[i + x][j + y].rgbtGreen * Gy[x + 1][y + 1];
                    Gy_v[2] += image[i + x][j + y].rgbtBlue * Gy[x + 1][y + 1];
                }
            }

            Gxy[0] = round(sqrt((Gx_v[0] * Gx_v[0]) + (Gy_v[0] * Gy_v[0])));
            Gxy[1] = round(sqrt((Gx_v[1] * Gx_v[1]) + (Gy_v[1] * Gy_v[1])));
            Gxy[2] = round(sqrt((Gx_v[2] * Gx_v[2]) + (Gy_v[2] * Gy_v[2])));

            if (Gxy[0] > 255)
            {
                Gxy[0] = 255;
            }

            if (Gxy[1] > 255)
            {
                Gxy[1] = 255;
            }

            if (Gxy[2] > 255)
            {
                Gxy[2] = 255;
            }

            aux[i][j].rgbtRed = Gxy[0];
            aux[i][j].rgbtGreen = Gxy[1];
            aux[i][j].rgbtBlue = Gxy[2];
        }
    }

    for (i = 0; i < height; i++)
    {
        for (j = 0; j < width; j++)
        {
            image[i][j].rgbtRed = aux[i][j].rgbtRed;
            image[i][j].rgbtGreen = aux[i][j].rgbtGreen;
            image[i][j].rgbtBlue = aux[i][j].rgbtBlue;
        }
    }
    return;
}

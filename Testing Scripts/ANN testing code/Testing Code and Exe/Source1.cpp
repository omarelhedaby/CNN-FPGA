#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <fstream>
using namespace std;

int main()
{

	int layer_num;

	/**********   Get the layer number  **********/
	cout << "Enter Layer # " << endl;
	cin >> layer_num;

	string WEIGHTS_FILE_NAME = "weightsdense_" + to_string(layer_num) + ".txt";
	string IN_FILE_NAME = "input_layer" + to_string(layer_num) + ".txt";
	string OUT_FILE_NAME = "output_layer" + to_string(layer_num) + ".txt";
	string OUT_FILE_NAME2 = "input_layer" + to_string(layer_num + 1) + ".txt";

	const int NUM_INPUTS = 84;
	const int NUM_OUTPUTS = 10;
	/*********************************************/


	/******* Vectors X,Y and Matrix W ********/
	float x[NUM_INPUTS], y[NUM_OUTPUTS], w[NUM_INPUTS][NUM_OUTPUTS];

	/******* File stream constructors *******/
	ifstream fin(WEIGHTS_FILE_NAME);

	ofstream foutY(OUT_FILE_NAME);
	ofstream foutY2(OUT_FILE_NAME2);

	/**** For first layer - generate random numbers *****/

	if (layer_num == 1)
	{
		srand((unsigned int)time(NULL));

		//Generate random numbers for the inputs 
		ofstream fout(IN_FILE_NAME);
		float maxFloat = 1;
		for (int i = 0; i < NUM_INPUTS; i++)
		{
			x[i] = (float(rand()) / float((RAND_MAX)) * maxFloat);
			//save them at the output file 
			fout << x[i] << endl;
		}
		fout.close();
	}/**** For subsequent layers - read the previous generated output *******/
	else
	{
		ifstream fin_X(IN_FILE_NAME);
		for (int i = 0; i < NUM_INPUTS; i++)
		{
			fin_X >> x[i];
		}
		fin_X.close();
	}

	/****** Read the weights ***********/
	for (int i = 0; i < NUM_INPUTS; i++)
		for (int j = 0; j < NUM_OUTPUTS; j++)
			fin >> w[i][j];

	/********* Compute the Layer Output ********/
	//Compute the first layer output 	
	for (int j = 0; j < NUM_OUTPUTS; j++)
	{
		y[j] = 0;
		for (int i = 0; i < NUM_INPUTS; i++)
			y[j] += x[i] * w[i][j];
		/**** Activation Function ****/
		//y[j] = tanh(y[j]);

		foutY << y[j] << endl;
		foutY2 << y[j] << endl;

	}



	foutY.close();
	foutY2.close();

	return 0;
}

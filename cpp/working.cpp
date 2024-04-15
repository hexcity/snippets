#include <iostream>
#include <iomanip>
using namespace std;

int main()
{
    float myfloat = 0;

    cout << "Hello world" << endl;
    cout << "ints are: " << sizeof(int) << " floats are: " << sizeof(float) << " double is: " << sizeof(double) << endl;

    cout << fixed;
    cout << setprecision(2);
    cout << "My float=" << myfloat << endl;
    myfloat = 3.336466;
    cout << "My float=" << myfloat << endl;

    return 0;
}
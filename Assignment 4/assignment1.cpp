#include<iostream>
using namespace std;


int main(void)
{
	int n,iteration[100],predbit[100],actout[100],update[100],i;
	int success_rate=0,failure_rate=0;
	predbit[0]=0;
	cout<<"enter the number of actual outcomes\n";

	cin>>n;
	for(i=0;i<n;i++)
	{
		cout<<"actout["<<i+1<<"]:";
        	cin>>actout[i];
	}
		
	predbit[0]=0;
	
	for(i=0;i<n;i++)
	{
		if(predbit[i]==actout[i])
		{
			update[i]=actout[i];
			predbit[i+1]=update[i];
			success_rate++;
		}
		else
		{
			update[i]=actout[i];
			predbit[i+1]=update[i];
			failure_rate++;
		}
	
	}

	cout<<"\niteration\tpredictionbit\tactualoutcome\tupdate";
	for(i=0;i<n;i++)
	{
 		cout<<"\nI["<<i+1<<"]"<<"\t\t"<<predbit[i]<<"\t\t"<<actout[i]<<"\t\t"<<update[i]<<"\n";
	}
	cout<<"Success rate:"<<success_rate<<"\nFailure rate:"<<failure_rate<<"\n";
}

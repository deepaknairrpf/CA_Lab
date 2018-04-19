#include<iostream>
using namespace std;
int main(void)
{
	int a[10],b[10],c[10],d[10],e[10];
	int n,i;

	cout<<"enter the no.of actual inputs\n";
	cin>>n;
	
	cout<<"enter the first input\n";
	for(i=0;i<n;i++)
	{
		cout<<"a["<<i+1<<"]:";
        	cin>>a[i];
	}
	b[0]=0;
	c[0]=0;	
	d[0]=0;
	e[0]=0;
	for(i=0;i<n;i++){
		
		if(a[i]==0&&b[i]==0&&c[i]==0)
		{
			d[i]=0;
			e[i]=0;
		}else if(a[i]==0&&b[i]==0&&c[i]==1)
		{
			d[i]=0;
			e[i]=0;
		}else if(a[i]==0&&b[i]==1&&c[i]==0)
		{
			d[i]=0;
			e[i]=0;
		}else if(a[i]==0&&b[i]==1&&c[i]==1)
		{
			d[i]=1;
			e[i]=0;
		}else if(a[i]==1&&b[i]==0&&c[i]==0)
		{
			d[i]=0;
			e[i]=1;
		}else if(a[i]==1&&b[i]==0&&c[i]==1)
		{
			d[i]=1;
			e[i]=1;
		}else if(a[i]==1&&b[i]==1&&c[i]==0)
		{
			d[i]=1;
			e[i]=1;
		}
		else if(a[i]==1&&b[i]==1&&c[i]==1)
		{
			d[i]=1;
			e[i]=1;
		}
		b[i+1]=d[i];
		c[i+1]=e[i];
		//cout<<"\nI["<<i+1<<"]"<<"\t\t"<<a[i]<<"\t\t"<<b[i]<<"\t\t"<<c[i]<<"\t\t"<<d[i]<<"\t\t"<<e[i]<<"\t\t";
	}
	
	
	cout<<"insno\t\tarray1\t\tarray2\t\tarray3\t\touts1\t\touts2\t\t";
	for(i=0;i<n;i++)
	{
		 cout<<"\nI["<<i+1<<"]"<<"\t\t"<<a[i]<<"\t\t"<<b[i]<<"\t\t"<<c[i]<<"\t\t"<<d[i]<<"\t\t"<<e[i]<<"\t\t";
	}
	cout<<"\n";
	return(0);
}

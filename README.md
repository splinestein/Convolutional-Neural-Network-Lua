# Convolutional-Neural-Network-Lua
## Convolutional Neural Network in Lua, brought to you by Github user splinestein.

<img src="https://doy2mn9upadnk.cloudfront.net/uploads/default/original/4X/8/1/d/81da87f6108f57be95eefaf713da44ca7927ebaa.gif" width="325" height="250"/>

Example:
```Lua
-- Feed:
0,0,0,0,0
0,1,1,1,0
0,0,0,1,0
0,0,0,1,0
0,0,0,1,0

-- Filter:
1,0,1
0,1,0
1,0,1

-- Output:
1,2,1,
1,3,2,
0,2,1
```

This matrix will be called a kernel. It should be noted that kernels size is dependent on the filter and feeds size. Here it is 3x3. It is in a sense sliding from left to right multiplying it by each cell in the feed by the filter, the filter is sliding across it multiplying the cells then setting it to the new sum, allocating the 2d array on the rows each slide only allocating to the columns once the filter cant slide anymore because it had reached the end of the feed. The filter cannot go out of the feeds bounds.

How can we create a system that does this, which takes into account any size of Feed and Filter, and create an appropriate Output?

## Approach:

Approach the problem from a 1 dimensional perspective:
```Lua
{0, 1, 0, 1, 0, 1, 0}
{1, 0, 1}
```
Say your first row is 7 blocks long, how many 3 blocks can fit by jumping by 1 each iteration? I kept my eye on the first index of the filter. How many times can that first index stay inside the 7 blocks without having the entire row go out of bounds? If you take 7 - 3 you get 4 times right? But if you calculate it, you’ll see that you could do it 5 times. This is because the first placement isn’t counted, we’re always adding by 1 from the beginning of our calculation, so add 1. That’s how I got my matrix_fitting. Now if you take a larger filter you’ll see that this logic will now apply to it perfectly.

```Lua
matrix_fitting = (#base - #filter) + 1
```

Now we can use this fitting to calculate the output. So in this example I’m talking about, (7 - 3) + 1 = 5, so we construct a 5 x 5 output and fill it with empty values.

Now we calculate the possible fittings in the base Y, and loop X inside. X always jumps N amount of times (matrix_fitting times) each Y iteration so the X for loop goes inside Y obviously.

Now inside this base matrix X loop, we can start our filter matrix calculation, looping through X within Y the length of the filter.

So now all we do is make a new fitting, take the position in the base and calculate the y and x on top of it respectively to get the position of where the filters current index is in the base - 1 due to index problem caused by for loops starting at 1.

```Lua
if base[(mxf_y + y)-1][(mxf_x + x)-1] * filter[y][x] >= 1 then
```

Now we calculate the value of the fittings value that got returned against our filters value which it is currently on and multiplies it. If it returns 1 or greater (which it would if you have 2’s or something), then we can simply take the position of the output and add 1 to it. If the loop finds another 1 in the current frame, it adds another +1 to that very same output index value.

(Btw if you want to check if the filter is greater than the base it’ll be super easy: If the matrix_fitting is below 0)

When the loop is done, we can output the matrix!

The code works with non equal sided matrices, like for example a base matrix: 9 x 7 that can get mapped on etc a 3 x 5 filter.

It also takes into account any base or filter values that are higher than 1 and appropriately calculates the sum.

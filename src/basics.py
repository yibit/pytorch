#!/bin/python

import torch

a = torch.Tensor([[2,3],[5,6],[7,8]])
print('a is: {}'.format(a))
print('a.size() is: {}'.format(a.size()))

b = torch.LongTensor([[2,3],[5,6],[7,9]])
print('b is: {}'.format(b))
print('b.size() is: {}'.format(b.size()))

c = torch.zeros((3,2))
print('c is: {}'.format(c))
print('c.size() is: {}'.format(c.size()))

d = torch.randn((3,2))
print('d is: {}'.format(d))
print('d.size() is: {}'.format(d.size()))


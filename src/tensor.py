#!/bin/python

import tensorflow as tf

a = tf.constant(1, dtype=tf.int16)
b = tf.constant(2, dtype=tf.int16)

c = tf.multiply(a, b)
d = tf.add(a, b)
e = tf.add(c, d)

sess = tf.Session()
out  = sess.run(e)

writer = tf.summary.FileWriter("./tensorflow_viz", sess.graph)

writer.close()
sess.close()

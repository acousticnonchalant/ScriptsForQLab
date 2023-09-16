FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ,& 

9/16/2023
Tested with QLab v5.2.3 on macOS Ventura 13.5.2

Active Cue Level Adjust
This script will change volume on all CURRENTLY PLAYING tracks. Will only work in edit mode.
See below for user variables, such as whether or not you want to set an absolute level or a relative level, what the level will be, and whether to check if in edit mode.
You should put this script into a script cue and trigger it with a hotkey from a Stream Deck, or give it a unique number and trigger it from Companion.

Written by Chase Elison 
chase@chaseelison.com

     � 	 	L   
 
 9 / 1 6 / 2 0 2 3 
 T e s t e d   w i t h   Q L a b   v 5 . 2 . 3   o n   m a c O S   V e n t u r a   1 3 . 5 . 2 
 
 A c t i v e   C u e   L e v e l   A d j u s t 
 T h i s   s c r i p t   w i l l   c h a n g e   v o l u m e   o n   a l l   C U R R E N T L Y   P L A Y I N G   t r a c k s .   W i l l   o n l y   w o r k   i n   e d i t   m o d e . 
 S e e   b e l o w   f o r   u s e r   v a r i a b l e s ,   s u c h   a s   w h e t h e r   o r   n o t   y o u   w a n t   t o   s e t   a n   a b s o l u t e   l e v e l   o r   a   r e l a t i v e   l e v e l ,   w h a t   t h e   l e v e l   w i l l   b e ,   a n d   w h e t h e r   t o   c h e c k   i f   i n   e d i t   m o d e . 
 Y o u   s h o u l d   p u t   t h i s   s c r i p t   i n t o   a   s c r i p t   c u e   a n d   t r i g g e r   i t   w i t h   a   h o t k e y   f r o m   a   S t r e a m   D e c k ,   o r   g i v e   i t   a   u n i q u e   n u m b e r   a n d   t r i g g e r   i t   f r o m   C o m p a n i o n . 
 
 W r i t t e n   b y   C h a s e   E l i s o n   
 c h a s e @ c h a s e e l i s o n . c o m 
 
   
  
 l     ��������  ��  ��        l     ��������  ��  ��        l     ����  r         m     ��
�� boovfals  o      ���� (0 onlyworkineditmode onlyWorkInEditMode��  ��        l     ��������  ��  ��        l     ��  ��    � � Change the value to true and change the absolute level if you wish to set the level to a defined level and not a relative level     �      C h a n g e   t h e   v a l u e   t o   t r u e   a n d   c h a n g e   t h e   a b s o l u t e   l e v e l   i f   y o u   w i s h   t o   s e t   t h e   l e v e l   t o   a   d e f i n e d   l e v e l   a n d   n o t   a   r e l a t i v e   l e v e l      l    ����  r        m    ��
�� boovfals  o      ���� &0 makeabsolutelevel makeAbsoluteLevel��  ��         l    !���� ! r     " # " m    	����   # o      ���� 0 absolutelevel absoluteLevel��  ��      $ % $ l     ��������  ��  ��   %  & ' & l     �� ( )��   ( K E Change this level if you want to add/subtract from the current level    ) � * * �   C h a n g e   t h i s   l e v e l   i f   y o u   w a n t   t o   a d d / s u b t r a c t   f r o m   t h e   c u r r e n t   l e v e l '  + , + l    -���� - r     . / . m    ����  / o      ���� 0 relativelevel relativeLevel��  ��   ,  0 1 0 l     ��������  ��  ��   1  2 3 2 l   � 4���� 4 O   � 5 6 5 O    � 7 8 7 k    � 9 9  : ; : Z    . < =�� > < o     ���� (0 onlyworkineditmode onlyWorkInEditMode = r   # ( ? @ ? 1   # &��
�� 
qIEM @ o      ���� 0 doscript doScript��   > r   + . A B A m   + ,��
�� boovtrue B o      ���� 0 doscript doScript ;  C�� C Z   / � D E���� D =  / 2 F G F o   / 0���� 0 doscript doScript G m   0 1��
�� boovtrue E k   5 � H H  I J I r   5 : K L K 1   5 8��
�� 
actQ L o      ���� 0 theselection theSelection J  M�� M X   ; � N�� O N Z   K � P Q���� P F   K v R S R F   K h T U T E  K Z V W V J   K T X X  Y Z Y m   K L [ [ � \ \ 
 A u d i o Z  ] ^ ] m   L O _ _ � ` ` 
 V i d e o ^  a�� a m   O R b b � c c  M i c��   W n   T Y d e d 1   U Y��
�� 
qTyp e o   T U���� 0 eachcue eachCue U =  ] d f g f n   ] b h i h 1   ^ b��
�� 
qRun i o   ] ^���� 0 eachcue eachCue g m   b c��
�� boovtrue S =  k r j k j n   k p l m l 1   l p��
�� 
qPRE m o   k l���� 0 eachcue eachCue k m   p q����   Q k   y � n n  o p o l  y y�� q r��   q � �If the cue is an audio or video cue, and the cue is running (not paused), and the cue is not pre-waiting, then the current cue is a match.    r � s s I f   t h e   c u e   i s   a n   a u d i o   o r   v i d e o   c u e ,   a n d   t h e   c u e   i s   r u n n i n g   ( n o t   p a u s e d ) ,   a n d   t h e   c u e   i s   n o t   p r e - w a i t i n g ,   t h e n   t h e   c u r r e n t   c u e   i s   a   m a t c h . p  t�� t O   y � u v u Z   � � w x�� y w =  � � z { z o   � ����� &0 makeabsolutelevel makeAbsoluteLevel { m   � ���
�� boovtrue x k   � � | |  } ~ } l  � ���  ���    J DIf the user wants to set the level to an absolute level, then do so!    � � � � � I f   t h e   u s e r   w a n t s   t o   s e t   t h e   l e v e l   t o   a n   a b s o l u t e   l e v e l ,   t h e n   d o   s o ! ~  ��� � I  � ��� � �
�� .QLablevsnull���     aCue � o   � ����� 0 eachcue eachCue � �� � �
�� 
levR � m   � �����   � �� � �
�� 
levC � m   � �����   � �� ���
�� 
levD � o   � ����� 0 absolutelevel absoluteLevel��  ��  ��   y k   � � � �  � � � l  � ��� � ���   � h bIf the user does not want an absolute level, then add the definied relative level to current level    � � � � � I f   t h e   u s e r   d o e s   n o t   w a n t   a n   a b s o l u t e   l e v e l ,   t h e n   a d d   t h e   d e f i n i e d   r e l a t i v e   l e v e l   t o   c u r r e n t   l e v e l �  � � � r   � � � � � I  � ��� � �
�� .QLablevgnull���     aCue � o   � ����� 0 eachcue eachCue � �� � �
�� 
levR � m   � �����   � �� ���
�� 
levC � m   � �����  ��   � o      ���� 0 currentlevel currentLevel �  � � � r   � � � � � [   � � � � � o   � ����� 0 currentlevel currentLevel � o   � ����� 0 relativelevel relativeLevel � o      ���� 0 newlevel newLevel �  ��� � I  � ��� � �
�� .QLablevsnull���     aCue � o   � ����� 0 eachcue eachCue � �� � �
�� 
levR � m   � �����   � �� � �
�� 
levC � m   � �����   � �� ���
�� 
levD � o   � ����� 0 newlevel newLevel��  ��   v 4  y }�� �
�� 
qDoc � m   { |���� ��  ��  ��  �� 0 eachcue eachCue O o   > ?���� 0 theselection theSelection��  ��  ��  ��   8 4   �� �
�� 
qDoc � m    ����  6 5    �� ���
�� 
capp � m     � � � � � & c o m . f i g u r e 5 3 . Q L a b . 5
�� kfrmID  ��  ��   3  � � � l     ��������  ��  ��   �  ��� � l      �� � ���   � = 7

Changes-
9/16/23 - No change, just verified working

    � � � � n 
 
 C h a n g e s - 
 9 / 1 6 / 2 3   -   N o   c h a n g e ,   j u s t   v e r i f i e d   w o r k i n g 
 
��       �� � ���   � ��
�� .aevtoappnull  �   � **** � �� ����� � ���
�� .aevtoappnull  �   � **** � k     � � �   � �   � �   � �  + � �  2����  ��  ��   � ���� 0 eachcue eachCue � ���������� �������~�}�|�{�z�y [ _ b�x�w�v�u�t�s�r�q�p�o�n�m�l�� (0 onlyworkineditmode onlyWorkInEditMode�� &0 makeabsolutelevel makeAbsoluteLevel�� 0 absolutelevel absoluteLevel�� 0 relativelevel relativeLevel
�� 
capp
�� kfrmID  
�� 
qDoc
� 
qIEM�~ 0 doscript doScript
�} 
actQ�| 0 theselection theSelection
�{ 
kocl
�z 
cobj
�y .corecnte****       ****
�x 
qTyp
�w 
qRun
�v 
bool
�u 
qPRE
�t 
levR
�s 
levC
�r 
levD�q 
�p .QLablevsnull���     aCue�o 
�n .QLablevgnull���     aCue�m 0 currentlevel currentLevel�l 0 newlevel newLevel�� �fE�OfE�OjE�OkE�O)���0 �*�k/ �� 
*�,E�Y eE�O�e  �*�,E�O ��[��l kh  �a a mv�a ,	 �a ,e a &	 �a ,j a & \*�k/ Q�e  �a ja ja �a  Y 5�a ja ja  E` O_ �E` O�a ja ja _ a  UY h[OY�qY hUU ascr  ��ޭ
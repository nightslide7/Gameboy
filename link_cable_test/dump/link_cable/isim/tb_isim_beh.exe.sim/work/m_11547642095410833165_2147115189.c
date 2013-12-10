/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "/Gameboy/Gameboy_git/link_cable.v";
static int ng1[] = {1, 0};
static unsigned int ng2[] = {0U, 0U};
static unsigned int ng3[] = {1U, 0U};
static int ng4[] = {0, 0};
static unsigned int ng5[] = {7U, 0U};
static unsigned int ng6[] = {8U, 0U};
static int ng7[] = {7, 0};



static void Cont_40_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;

LAB0:    t1 = (t0 + 5880U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(40, ng0);
    t2 = (t0 + 1528U);
    t3 = *((char **)t2);
    t2 = (t0 + 7864);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    memset(t7, 0, 8);
    t8 = 1U;
    t9 = t8;
    t10 = (t3 + 4);
    t11 = *((unsigned int *)t3);
    t8 = (t8 & t11);
    t12 = *((unsigned int *)t10);
    t9 = (t9 & t12);
    t13 = (t7 + 4);
    t14 = *((unsigned int *)t7);
    *((unsigned int *)t7) = (t14 | t8);
    t15 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t15 | t9);
    xsi_driver_vfirst_trans(t2, 0, 0);
    t16 = (t0 + 7688);
    *((int *)t16) = 1;

LAB1:    return;
}

static void Cont_41_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;

LAB0:    t1 = (t0 + 6128U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(41, ng0);
    t2 = (t0 + 4008);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 7928);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memset(t9, 0, 8);
    t10 = 1U;
    t11 = t10;
    t12 = (t4 + 4);
    t13 = *((unsigned int *)t4);
    t10 = (t10 & t13);
    t14 = *((unsigned int *)t12);
    t11 = (t11 & t14);
    t15 = (t9 + 4);
    t16 = *((unsigned int *)t9);
    *((unsigned int *)t9) = (t16 | t10);
    t17 = *((unsigned int *)t15);
    *((unsigned int *)t15) = (t17 | t11);
    xsi_driver_vfirst_trans(t5, 0, 0);
    t18 = (t0 + 7704);
    *((int *)t18) = 1;

LAB1:    return;
}

static void Cont_42_2(char *t0)
{
    char t3[8];
    char t6[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    char *t21;
    char *t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    unsigned int t30;
    unsigned int t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;
    char *t36;
    unsigned int t37;
    unsigned int t38;
    char *t39;
    unsigned int t40;
    unsigned int t41;
    char *t42;
    unsigned int t43;
    unsigned int t44;
    char *t45;

LAB0:    t1 = (t0 + 6376U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(42, ng0);
    t2 = (t0 + 4968);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    t7 = (t6 + 4);
    t8 = (t5 + 4);
    t9 = *((unsigned int *)t5);
    t10 = (t9 >> 0);
    t11 = (t10 & 1);
    *((unsigned int *)t6) = t11;
    t12 = *((unsigned int *)t8);
    t13 = (t12 >> 0);
    t14 = (t13 & 1);
    *((unsigned int *)t7) = t14;
    memset(t3, 0, 8);
    t15 = (t6 + 4);
    t16 = *((unsigned int *)t15);
    t17 = (~(t16));
    t18 = *((unsigned int *)t6);
    t19 = (t18 & t17);
    t20 = (t19 & 1U);
    if (t20 != 0)
        goto LAB7;

LAB5:    if (*((unsigned int *)t15) == 0)
        goto LAB4;

LAB6:    t21 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t21) = 1;

LAB7:    t22 = (t3 + 4);
    t23 = (t6 + 4);
    t24 = *((unsigned int *)t6);
    t25 = (~(t24));
    *((unsigned int *)t3) = t25;
    *((unsigned int *)t22) = 0;
    if (*((unsigned int *)t23) != 0)
        goto LAB9;

LAB8:    t30 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t30 & 1U);
    t31 = *((unsigned int *)t22);
    *((unsigned int *)t22) = (t31 & 1U);
    t32 = (t0 + 7992);
    t33 = (t32 + 56U);
    t34 = *((char **)t33);
    t35 = (t34 + 56U);
    t36 = *((char **)t35);
    memset(t36, 0, 8);
    t37 = 1U;
    t38 = t37;
    t39 = (t3 + 4);
    t40 = *((unsigned int *)t3);
    t37 = (t37 & t40);
    t41 = *((unsigned int *)t39);
    t38 = (t38 & t41);
    t42 = (t36 + 4);
    t43 = *((unsigned int *)t36);
    *((unsigned int *)t36) = (t43 | t37);
    t44 = *((unsigned int *)t42);
    *((unsigned int *)t42) = (t44 | t38);
    xsi_driver_vfirst_trans(t32, 0, 0);
    t45 = (t0 + 7720);
    *((int *)t45) = 1;

LAB1:    return;
LAB4:    *((unsigned int *)t3) = 1;
    goto LAB7;

LAB9:    t26 = *((unsigned int *)t3);
    t27 = *((unsigned int *)t23);
    *((unsigned int *)t3) = (t26 | t27);
    t28 = *((unsigned int *)t22);
    t29 = *((unsigned int *)t23);
    *((unsigned int *)t22) = (t28 | t29);
    goto LAB8;

}

static void Always_57_3(char *t0)
{
    char t13[8];
    char t30[8];
    char t33[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    char *t11;
    char *t12;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    int t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    unsigned int t29;
    char *t31;
    char *t32;
    char *t34;
    char *t35;
    char *t36;
    char *t37;
    unsigned int t38;
    unsigned int t39;
    unsigned int t40;
    unsigned int t41;
    unsigned int t42;
    unsigned int t43;
    char *t44;
    unsigned int t45;
    unsigned int t46;
    unsigned int t47;
    unsigned int t48;
    unsigned int t49;
    unsigned int t50;
    unsigned int t51;
    unsigned int t52;
    int t53;
    unsigned int t54;
    unsigned int t55;
    unsigned int t56;
    unsigned int t57;
    unsigned int t58;

LAB0:    t1 = (t0 + 6624U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(57, ng0);
    t2 = (t0 + 7736);
    *((int *)t2) = 1;
    t3 = (t0 + 6656);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(57, ng0);

LAB5:    xsi_set_current_line(58, ng0);
    t4 = (t0 + 1208U);
    t5 = *((char **)t4);
    t4 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(66, ng0);

LAB10:    xsi_set_current_line(67, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(68, ng0);
    t2 = (t0 + 4328);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t5, t4, 0, 0, 1, 0LL);
    xsi_set_current_line(69, ng0);
    t2 = (t0 + 4648);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng5)));
    memset(t13, 0, 8);
    t11 = (t4 + 4);
    if (*((unsigned int *)t11) != 0)
        goto LAB12;

LAB11:    t12 = (t5 + 4);
    if (*((unsigned int *)t12) != 0)
        goto LAB12;

LAB15:    if (*((unsigned int *)t4) > *((unsigned int *)t5))
        goto LAB14;

LAB13:    *((unsigned int *)t13) = 1;

LAB14:    t15 = (t13 + 4);
    t6 = *((unsigned int *)t15);
    t7 = (~(t6));
    t8 = *((unsigned int *)t13);
    t9 = (t8 & t7);
    t10 = (t9 != 0);
    if (t10 > 0)
        goto LAB16;

LAB17:    xsi_set_current_line(84, ng0);
    t2 = (t0 + 4648);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng6)));
    memset(t13, 0, 8);
    t11 = (t4 + 4);
    t12 = (t5 + 4);
    t6 = *((unsigned int *)t4);
    t7 = *((unsigned int *)t5);
    t8 = (t6 ^ t7);
    t9 = *((unsigned int *)t11);
    t10 = *((unsigned int *)t12);
    t25 = (t9 ^ t10);
    t26 = (t8 | t25);
    t27 = *((unsigned int *)t11);
    t28 = *((unsigned int *)t12);
    t29 = (t27 | t28);
    t38 = (~(t29));
    t39 = (t26 & t38);
    if (t39 != 0)
        goto LAB45;

LAB42:    if (t29 != 0)
        goto LAB44;

LAB43:    *((unsigned int *)t13) = 1;

LAB45:    t15 = (t13 + 4);
    t40 = *((unsigned int *)t15);
    t41 = (~(t40));
    t42 = *((unsigned int *)t13);
    t43 = (t42 & t41);
    t45 = (t43 != 0);
    if (t45 > 0)
        goto LAB46;

LAB47:
LAB48:
LAB18:    xsi_set_current_line(90, ng0);
    t2 = (t0 + 2488U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t13) = t8;
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t11 = (t13 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t5);
    t25 = (t9 | t10);
    *((unsigned int *)t11) = t25;
    t26 = *((unsigned int *)t11);
    t27 = (t26 != 0);
    if (t27 == 1)
        goto LAB52;

LAB53:
LAB54:    t15 = (t13 + 4);
    t54 = *((unsigned int *)t15);
    t55 = (~(t54));
    t56 = *((unsigned int *)t13);
    t57 = (t56 & t55);
    t58 = (t57 != 0);
    if (t58 > 0)
        goto LAB55;

LAB56:
LAB57:    xsi_set_current_line(93, ng0);
    t2 = (t0 + 2488U);
    t3 = *((char **)t2);
    t2 = (t0 + 2168U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t13) = t8;
    t2 = (t3 + 4);
    t5 = (t4 + 4);
    t11 = (t13 + 4);
    t9 = *((unsigned int *)t2);
    t10 = *((unsigned int *)t5);
    t25 = (t9 | t10);
    *((unsigned int *)t11) = t25;
    t26 = *((unsigned int *)t11);
    t27 = (t26 != 0);
    if (t27 == 1)
        goto LAB59;

LAB60:
LAB61:    t15 = (t13 + 4);
    t54 = *((unsigned int *)t15);
    t55 = (~(t54));
    t56 = *((unsigned int *)t13);
    t57 = (t56 & t55);
    t58 = (t57 != 0);
    if (t58 > 0)
        goto LAB62;

LAB63:
LAB64:
LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(58, ng0);

LAB9:    xsi_set_current_line(59, ng0);
    t11 = ((char*)((ng1)));
    t12 = (t0 + 4168);
    xsi_vlogvar_wait_assign_value(t12, t11, 0, 0, 1, 0LL);
    xsi_set_current_line(60, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4808);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    xsi_set_current_line(61, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(62, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4968);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 8, 0LL);
    xsi_set_current_line(63, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4648);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 5, 0LL);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB8;

LAB12:    t14 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t14) = 1;
    goto LAB14;

LAB16:    xsi_set_current_line(69, ng0);

LAB19:    xsi_set_current_line(70, ng0);
    t16 = (t0 + 4168);
    t17 = (t16 + 56U);
    t18 = *((char **)t17);

LAB20:    t19 = ((char*)((ng4)));
    t20 = xsi_vlog_unsigned_case_compare(t18, 1, t19, 32);
    if (t20 == 1)
        goto LAB21;

LAB22:    t2 = ((char*)((ng1)));
    t20 = xsi_vlog_unsigned_case_compare(t18, 1, t2, 32);
    if (t20 == 1)
        goto LAB23;

LAB24:
LAB25:    goto LAB18;

LAB21:    xsi_set_current_line(71, ng0);

LAB26:    xsi_set_current_line(72, ng0);
    t21 = (t0 + 4328);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 4);
    t25 = *((unsigned int *)t24);
    t26 = (~(t25));
    t27 = *((unsigned int *)t23);
    t28 = (t27 & t26);
    t29 = (t28 != 0);
    if (t29 > 0)
        goto LAB27;

LAB28:
LAB29:    goto LAB25;

LAB23:    xsi_set_current_line(77, ng0);

LAB31:    xsi_set_current_line(78, ng0);
    t3 = (t0 + 4328);
    t4 = (t3 + 56U);
    t5 = *((char **)t4);
    memset(t13, 0, 8);
    t11 = (t5 + 4);
    t6 = *((unsigned int *)t11);
    t7 = (~(t6));
    t8 = *((unsigned int *)t5);
    t9 = (t8 & t7);
    t10 = (t9 & 1U);
    if (t10 != 0)
        goto LAB35;

LAB33:    if (*((unsigned int *)t11) == 0)
        goto LAB32;

LAB34:    t12 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t12) = 1;

LAB35:    t14 = (t13 + 4);
    t15 = (t5 + 4);
    t25 = *((unsigned int *)t5);
    t26 = (~(t25));
    *((unsigned int *)t13) = t26;
    *((unsigned int *)t14) = 0;
    if (*((unsigned int *)t15) != 0)
        goto LAB37;

LAB36:    t39 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t39 & 1U);
    t40 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t40 & 1U);
    t16 = (t13 + 4);
    t41 = *((unsigned int *)t16);
    t42 = (~(t41));
    t43 = *((unsigned int *)t13);
    t45 = (t43 & t42);
    t46 = (t45 != 0);
    if (t46 > 0)
        goto LAB38;

LAB39:
LAB40:    goto LAB25;

LAB27:    xsi_set_current_line(72, ng0);

LAB30:    xsi_set_current_line(73, ng0);
    t31 = (t0 + 2968U);
    t32 = *((char **)t31);
    t31 = (t0 + 4808);
    t34 = (t31 + 56U);
    t35 = *((char **)t34);
    memset(t33, 0, 8);
    t36 = (t33 + 4);
    t37 = (t35 + 4);
    t38 = *((unsigned int *)t35);
    t39 = (t38 >> 0);
    *((unsigned int *)t33) = t39;
    t40 = *((unsigned int *)t37);
    t41 = (t40 >> 0);
    *((unsigned int *)t36) = t41;
    t42 = *((unsigned int *)t33);
    *((unsigned int *)t33) = (t42 & 127U);
    t43 = *((unsigned int *)t36);
    *((unsigned int *)t36) = (t43 & 127U);
    xsi_vlogtype_concat(t30, 8, 8, 2U, t33, 7, t32, 1);
    t44 = (t0 + 4808);
    xsi_vlogvar_wait_assign_value(t44, t30, 0, 0, 8, 0LL);
    xsi_set_current_line(74, ng0);
    t2 = (t0 + 4648);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t5 = ((char*)((ng1)));
    memset(t13, 0, 8);
    xsi_vlog_unsigned_add(t13, 32, t4, 5, t5, 32);
    t11 = (t0 + 4648);
    xsi_vlogvar_wait_assign_value(t11, t13, 0, 0, 5, 0LL);
    goto LAB29;

LAB32:    *((unsigned int *)t13) = 1;
    goto LAB35;

LAB37:    t27 = *((unsigned int *)t13);
    t28 = *((unsigned int *)t15);
    *((unsigned int *)t13) = (t27 | t28);
    t29 = *((unsigned int *)t14);
    t38 = *((unsigned int *)t15);
    *((unsigned int *)t14) = (t29 | t38);
    goto LAB36;

LAB38:    xsi_set_current_line(78, ng0);

LAB41:    xsi_set_current_line(79, ng0);
    t17 = (t0 + 4808);
    t19 = (t17 + 56U);
    t21 = *((char **)t19);
    memset(t30, 0, 8);
    t22 = (t30 + 4);
    t23 = (t21 + 4);
    t47 = *((unsigned int *)t21);
    t48 = (t47 >> 7);
    t49 = (t48 & 1);
    *((unsigned int *)t30) = t49;
    t50 = *((unsigned int *)t23);
    t51 = (t50 >> 7);
    t52 = (t51 & 1);
    *((unsigned int *)t22) = t52;
    t24 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t24, t30, 0, 0, 1, 0LL);
    goto LAB40;

LAB44:    t14 = (t13 + 4);
    *((unsigned int *)t13) = 1;
    *((unsigned int *)t14) = 1;
    goto LAB45;

LAB46:    xsi_set_current_line(84, ng0);

LAB49:    xsi_set_current_line(85, ng0);
    t16 = ((char*)((ng4)));
    t17 = (t0 + 4648);
    xsi_vlogvar_wait_assign_value(t17, t16, 0, 0, 5, 0LL);
    xsi_set_current_line(86, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3848);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    xsi_set_current_line(87, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4968);
    t4 = (t0 + 4968);
    t5 = (t4 + 72U);
    t11 = *((char **)t5);
    t12 = ((char*)((ng7)));
    xsi_vlog_generic_convert_bit_index(t13, t11, 2, t12, 32, 1);
    t14 = (t13 + 4);
    t6 = *((unsigned int *)t14);
    t20 = (!(t6));
    if (t20 == 1)
        goto LAB50;

LAB51:    xsi_set_current_line(88, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4008);
    xsi_vlogvar_wait_assign_value(t3, t2, 0, 0, 1, 0LL);
    goto LAB48;

LAB50:    xsi_vlogvar_wait_assign_value(t3, t2, 0, *((unsigned int *)t13), 1, 0LL);
    goto LAB51;

LAB52:    t28 = *((unsigned int *)t13);
    t29 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t28 | t29);
    t12 = (t3 + 4);
    t14 = (t4 + 4);
    t38 = *((unsigned int *)t3);
    t39 = (~(t38));
    t40 = *((unsigned int *)t12);
    t41 = (~(t40));
    t42 = *((unsigned int *)t4);
    t43 = (~(t42));
    t45 = *((unsigned int *)t14);
    t46 = (~(t45));
    t20 = (t39 & t41);
    t53 = (t43 & t46);
    t47 = (~(t20));
    t48 = (~(t53));
    t49 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t49 & t47);
    t50 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t50 & t48);
    t51 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t51 & t47);
    t52 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t52 & t48);
    goto LAB54;

LAB55:    xsi_set_current_line(90, ng0);

LAB58:    xsi_set_current_line(91, ng0);
    t16 = (t0 + 1848U);
    t17 = *((char **)t16);
    t16 = (t0 + 4968);
    xsi_vlogvar_wait_assign_value(t16, t17, 0, 0, 8, 0LL);
    goto LAB57;

LAB59:    t28 = *((unsigned int *)t13);
    t29 = *((unsigned int *)t11);
    *((unsigned int *)t13) = (t28 | t29);
    t12 = (t3 + 4);
    t14 = (t4 + 4);
    t38 = *((unsigned int *)t3);
    t39 = (~(t38));
    t40 = *((unsigned int *)t12);
    t41 = (~(t40));
    t42 = *((unsigned int *)t4);
    t43 = (~(t42));
    t45 = *((unsigned int *)t14);
    t46 = (~(t45));
    t20 = (t39 & t41);
    t53 = (t43 & t46);
    t47 = (~(t20));
    t48 = (~(t53));
    t49 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t49 & t47);
    t50 = *((unsigned int *)t11);
    *((unsigned int *)t11) = (t50 & t48);
    t51 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t51 & t47);
    t52 = *((unsigned int *)t13);
    *((unsigned int *)t13) = (t52 & t48);
    goto LAB61;

LAB62:    xsi_set_current_line(93, ng0);

LAB65:    xsi_set_current_line(94, ng0);
    t16 = (t0 + 1848U);
    t17 = *((char **)t16);
    t16 = (t0 + 4808);
    xsi_vlogvar_wait_assign_value(t16, t17, 0, 0, 8, 0LL);
    goto LAB64;

}

static void Always_99_4(char *t0)
{
    char t7[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t8;
    char *t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    char *t22;
    char *t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    unsigned int t28;
    char *t29;
    char *t30;

LAB0:    t1 = (t0 + 6872U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(99, ng0);
    t2 = (t0 + 7752);
    *((int *)t2) = 1;
    t3 = (t0 + 6904);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(99, ng0);

LAB5:    xsi_set_current_line(100, ng0);
    t4 = (t0 + 4968);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t7, 0, 8);
    t8 = (t7 + 4);
    t9 = (t6 + 4);
    t10 = *((unsigned int *)t6);
    t11 = (t10 >> 7);
    t12 = (t11 & 1);
    *((unsigned int *)t7) = t12;
    t13 = *((unsigned int *)t9);
    t14 = (t13 >> 7);
    t15 = (t14 & 1);
    *((unsigned int *)t8) = t15;
    t16 = (t7 + 4);
    t17 = *((unsigned int *)t16);
    t18 = (~(t17));
    t19 = *((unsigned int *)t7);
    t20 = (t19 & t18);
    t21 = (t20 != 0);
    if (t21 > 0)
        goto LAB6;

LAB7:    xsi_set_current_line(110, ng0);

LAB15:    xsi_set_current_line(111, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4488);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(112, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 4328);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);

LAB8:    goto LAB2;

LAB6:    xsi_set_current_line(100, ng0);

LAB9:    xsi_set_current_line(101, ng0);
    t22 = (t0 + 3128U);
    t23 = *((char **)t22);
    t22 = (t23 + 4);
    t24 = *((unsigned int *)t22);
    t25 = (~(t24));
    t26 = *((unsigned int *)t23);
    t27 = (t26 & t25);
    t28 = (t27 != 0);
    if (t28 > 0)
        goto LAB10;

LAB11:    xsi_set_current_line(105, ng0);

LAB14:    xsi_set_current_line(106, ng0);
    t2 = (t0 + 2808U);
    t3 = *((char **)t2);
    t2 = (t0 + 4328);
    xsi_vlogvar_assign_value(t2, t3, 0, 0, 1);
    xsi_set_current_line(107, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4488);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);

LAB12:    goto LAB8;

LAB10:    xsi_set_current_line(101, ng0);

LAB13:    xsi_set_current_line(102, ng0);
    t29 = (t0 + 1688U);
    t30 = *((char **)t29);
    t29 = (t0 + 4328);
    xsi_vlogvar_assign_value(t29, t30, 0, 0, 1);
    xsi_set_current_line(103, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 4488);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    goto LAB12;

}

static void implSig1_execute(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    int t28;
    int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t41;
    unsigned int t42;
    char *t43;
    unsigned int t44;
    unsigned int t45;
    char *t46;
    unsigned int t47;
    unsigned int t48;
    char *t49;

LAB0:    t1 = (t0 + 7120U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2648U);
    t3 = *((char **)t2);
    t2 = (t0 + 2168U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t5) = t8;
    t2 = (t3 + 4);
    t9 = (t4 + 4);
    t10 = (t5 + 4);
    t11 = *((unsigned int *)t2);
    t12 = *((unsigned int *)t9);
    t13 = (t11 | t12);
    *((unsigned int *)t10) = t13;
    t14 = *((unsigned int *)t10);
    t15 = (t14 != 0);
    if (t15 == 1)
        goto LAB4;

LAB5:
LAB6:    t36 = (t0 + 8056);
    t37 = (t36 + 56U);
    t38 = *((char **)t37);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    memset(t40, 0, 8);
    t41 = 1U;
    t42 = t41;
    t43 = (t5 + 4);
    t44 = *((unsigned int *)t5);
    t41 = (t41 & t44);
    t45 = *((unsigned int *)t43);
    t42 = (t42 & t45);
    t46 = (t40 + 4);
    t47 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t47 | t41);
    t48 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t48 | t42);
    xsi_driver_vfirst_trans(t36, 0, 0);
    t49 = (t0 + 7768);
    *((int *)t49) = 1;

LAB1:    return;
LAB4:    t16 = *((unsigned int *)t5);
    t17 = *((unsigned int *)t10);
    *((unsigned int *)t5) = (t16 | t17);
    t18 = (t3 + 4);
    t19 = (t4 + 4);
    t20 = *((unsigned int *)t3);
    t21 = (~(t20));
    t22 = *((unsigned int *)t18);
    t23 = (~(t22));
    t24 = *((unsigned int *)t4);
    t25 = (~(t24));
    t26 = *((unsigned int *)t19);
    t27 = (~(t26));
    t28 = (t21 & t23);
    t29 = (t25 & t27);
    t30 = (~(t28));
    t31 = (~(t29));
    t32 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t32 & t30);
    t33 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t33 & t31);
    t34 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t34 & t30);
    t35 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t35 & t31);
    goto LAB6;

}

static void implSig2_execute(char *t0)
{
    char t5[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    unsigned int t6;
    unsigned int t7;
    unsigned int t8;
    char *t9;
    char *t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    unsigned int t26;
    unsigned int t27;
    int t28;
    int t29;
    unsigned int t30;
    unsigned int t31;
    unsigned int t32;
    unsigned int t33;
    unsigned int t34;
    unsigned int t35;
    char *t36;
    char *t37;
    char *t38;
    char *t39;
    char *t40;
    unsigned int t41;
    unsigned int t42;
    char *t43;
    unsigned int t44;
    unsigned int t45;
    char *t46;
    unsigned int t47;
    unsigned int t48;
    char *t49;

LAB0:    t1 = (t0 + 7368U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    t2 = (t0 + 2648U);
    t3 = *((char **)t2);
    t2 = (t0 + 2328U);
    t4 = *((char **)t2);
    t6 = *((unsigned int *)t3);
    t7 = *((unsigned int *)t4);
    t8 = (t6 & t7);
    *((unsigned int *)t5) = t8;
    t2 = (t3 + 4);
    t9 = (t4 + 4);
    t10 = (t5 + 4);
    t11 = *((unsigned int *)t2);
    t12 = *((unsigned int *)t9);
    t13 = (t11 | t12);
    *((unsigned int *)t10) = t13;
    t14 = *((unsigned int *)t10);
    t15 = (t14 != 0);
    if (t15 == 1)
        goto LAB4;

LAB5:
LAB6:    t36 = (t0 + 8120);
    t37 = (t36 + 56U);
    t38 = *((char **)t37);
    t39 = (t38 + 56U);
    t40 = *((char **)t39);
    memset(t40, 0, 8);
    t41 = 1U;
    t42 = t41;
    t43 = (t5 + 4);
    t44 = *((unsigned int *)t5);
    t41 = (t41 & t44);
    t45 = *((unsigned int *)t43);
    t42 = (t42 & t45);
    t46 = (t40 + 4);
    t47 = *((unsigned int *)t40);
    *((unsigned int *)t40) = (t47 | t41);
    t48 = *((unsigned int *)t46);
    *((unsigned int *)t46) = (t48 | t42);
    xsi_driver_vfirst_trans(t36, 0, 0);
    t49 = (t0 + 7784);
    *((int *)t49) = 1;

LAB1:    return;
LAB4:    t16 = *((unsigned int *)t5);
    t17 = *((unsigned int *)t10);
    *((unsigned int *)t5) = (t16 | t17);
    t18 = (t3 + 4);
    t19 = (t4 + 4);
    t20 = *((unsigned int *)t3);
    t21 = (~(t20));
    t22 = *((unsigned int *)t18);
    t23 = (~(t22));
    t24 = *((unsigned int *)t4);
    t25 = (~(t24));
    t26 = *((unsigned int *)t19);
    t27 = (~(t26));
    t28 = (t21 & t23);
    t29 = (t25 & t27);
    t30 = (~(t28));
    t31 = (~(t29));
    t32 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t32 & t30);
    t33 = *((unsigned int *)t10);
    *((unsigned int *)t10) = (t33 & t31);
    t34 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t34 & t30);
    t35 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t35 & t31);
    goto LAB6;

}


extern void work_m_11547642095410833165_2147115189_init()
{
	static char *pe[] = {(void *)Cont_40_0,(void *)Cont_41_1,(void *)Cont_42_2,(void *)Always_57_3,(void *)Always_99_4,(void *)implSig1_execute,(void *)implSig2_execute};
	xsi_register_didat("work_m_11547642095410833165_2147115189", "isim/tb_isim_beh.exe.sim/work/m_11547642095410833165_2147115189.didat");
	xsi_register_executes(pe);
}

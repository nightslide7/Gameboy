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

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_08292215571755000178_1424557605_init();
    work_m_08292215571755000178_3393339049_init();
    work_m_11765053959798283853_2402909767_init();
    work_m_11547642095410833165_2147115189_init();
    work_m_08292215571755000178_0569331038_init();
    work_m_09293065866394350152_3671711236_init();
    work_m_16541823861846354283_2073120511_init();


    xsi_register_tops("work_m_09293065866394350152_3671711236");
    xsi_register_tops("work_m_16541823861846354283_2073120511");


    return xsi_run_simulation(argc, argv);

}

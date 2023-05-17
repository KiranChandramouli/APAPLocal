SUBROUTINE REDO.TT.GROUP.PARAM.VALIDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.TT.GROUP.PARAM.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.TT.GROUP.PARAM.VALIDATE is a validation routine attached to the TEMPLATE
*                    - REDO.TT.GROUP.PARAM, the routine checks if the duplicate value entered in the
*                    GROUP field
*Linked With       : Template - REDO.TT.GROUP.PARAM
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : REDO.TT.GROUP.PARAM           As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010       Sudharsanan S         PACS00062653                  Initial Creation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TT.GROUP.PARAM
*-------------------------------------------------------------------------------------------------------
    GOSUB CHECK.DUP
RETURN
*--------------------------------------------------------------------------------------------------------
**********
CHECK.DUP:
**********
    AF = TEL.GRO.GROUP
    CALL DUP

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program

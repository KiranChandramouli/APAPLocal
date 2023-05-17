SUBROUTINE REDO.APAP.CONV.DISP.STATUS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.DISP.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION Routine to attach to display the STATUS of the USER in multiple rows
*
*Linked With       : Enquiry
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : USER                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     28.10.2010           Mudassir V          ODR-2010-03-0095           Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPENFILE
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------
*********
OPENFILE:
**********
    Y.DATA  = ''

    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

RETURN
*-------------------------------------------------------------------------------------------------------
********
PROCESS:
********
    CHANGE ' ' TO @VM IN O.DATA
    VM.COUNT = DCOUNT(O.DATA,@VM)
    O.DATA   = O.DATA<1,VC>
    CHANGE '*' TO ' ' IN O.DATA

RETURN
*-------------------------------------------------------------------------------------------------------
END

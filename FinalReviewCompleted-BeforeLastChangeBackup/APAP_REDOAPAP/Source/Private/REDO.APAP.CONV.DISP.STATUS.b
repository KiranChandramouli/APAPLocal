* @ValidationCode : MjoxNDQxNTI4OTE5OkNwMTI1MjoxNjg0ODM2MDM1NzgwOklUU1M6LTE6LTE6Nzg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 78
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
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
* Date                  who                   Reference              
* 04-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION VM TO @VM
* 04-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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

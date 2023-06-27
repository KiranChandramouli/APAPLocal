* @ValidationCode : MjoxODA4MTU5ODc6Q3AxMjUyOjE2ODQ4MzYwMzgyMjg6SVRTUzotMTotMToxNzU6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 175
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.GET.COD.CLIENT
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.GET.ACCT.NAME
*--------------------------------------------------------------------------------------------------------
*Description       : This is a Conversion routine to get the names of the Customer
*
*Linked With       : Enquiry REDO.APAP.PROX.ACCT
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*Files  Used       : ACCOUNT                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     20.10.2010          Ganesh R              ODR-2010-03-0182            Initial Creation
* Date                  who                   Reference              
* 05-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION VM TO @VM
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.RELATION
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA

    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    Y.ACCT.ID = O.DATA

    Y.READ.ERR = ''
    R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, Y.READ.ERR)

    Y.RETURN.VAL = R.ACCOUNT<AC.CUSTOMER>
    Y.JOINT.HOLDERS = R.ACCOUNT<AC.JOINT.HOLDER>
    Y.RELATIONS = R.ACCOUNT<AC.RELATION.CODE>

    Y.LOOP.CNT = 1
    LOOP
        REMOVE Y.JOINT.ID FROM Y.JOINT.HOLDERS SETTING Y.JOINT.POS
    WHILE Y.JOINT.ID:Y.JOINT.POS

        Y.REL.CODE = Y.RELATIONS<1, Y.LOOP.CNT>
        IF Y.REL.CODE GT 500 AND Y.REL.CODE LE 529 THEN
            Y.RETURN.VAL<1, -1> = Y.JOINT.ID
        END

    REPEAT

*    VM.COUNT = DCOUNT(Y.RETURN.VAL, VM)
    Y.RETURN.VAL = CHANGE(Y.RETURN.VAL, @VM, '; ')

    O.DATA = Y.RETURN.VAL

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Prgram

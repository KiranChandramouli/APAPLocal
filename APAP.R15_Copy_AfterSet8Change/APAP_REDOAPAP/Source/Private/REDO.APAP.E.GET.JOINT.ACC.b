* @ValidationCode : Mjo0Mzg0ODYzNjY6Q3AxMjUyOjE2ODQ4MzYwMzgzMzY6SVRTUzotMTotMToxNzg6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 178
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE  REDO.APAP.E.GET.JOINT.ACC
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.GET.REL.CODE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.E.GET.REL.CODE is a conversion routine attached to the ENQUITY>
*                     REDO.APAP.PROX.ACCT, the routine fetches the value from O.DATA delimited with stars
*                     and formats them according to the selection criteria and returns the value back to O.DATA
*Linked With       :
*In  Parameter     : O.DATA
*Out Parameter     : O.DATA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 18 OCT 2010             Mudassir V           ODR-2010-03-0182        Initial Creation
* Date                   who                   Reference              
* 05-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND ++ TO  += 1
* 05-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES

*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.FILE
    GOSUB PROCESS.PARA

RETURN
*-------------------------------------------------------------------------------------------------------
************
OPEN.FILE:
*************
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN

*---------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    ACC.ID = O.DATA
    O.DATA = ''
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE>
    REL.COUNT = DCOUNT(VAR.RELATION.CODE,@VM)
    VAR.COUNT = 1
    IF VAR.RELATION.CODE THEN
        LOOP
            REMOVE REL.ID FROM VAR.RELATION.CODE SETTING REL.POS
        WHILE VAR.COUNT LE REL.COUNT
            IF REL.ID GE 530 AND REL.ID LE 549 THEN
                O.DATA<-1> = R.ACCOUNT<AC.JOINT.HOLDER,VAR.COUNT>
            END
            VAR.COUNT += 1  ;*R22 AUTO CONVERSTION ++ TO += 1
        REPEAT
    END
RETURN
END

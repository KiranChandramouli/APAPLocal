* @ValidationCode : MjoxMzA4NTczNjc1OkNwMTI1MjoxNjg0ODM2MDM2ODYzOklUU1M6LTE6LTE6MTkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 190
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.DEAL.CONV.VAL(Y.VAL)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.VAL
*Reference Number  :ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to display N/A text if value is not present
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

OPENFILE:
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
RETURN

PROCESS:

    LOC.POS = ''
    CALL MULTI.GET.LOC.REF('CUSTOMER','L.CU.RNC',LOC.POS)
    VAR.RNC.POS = LOC.POS
    CALL F.READ(FN.CUSTOMER,Y.VAL,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    VAR.RNC = R.CUSTOMER<EB.CUS.LOCAL.REF><1,VAR.RNC.POS>

    IF VAR.RNC EQ '' THEN
        Y.VAL = 'N/A'
    END
    ELSE
        Y.VAL = VAR.RNC
    END
RETURN
END

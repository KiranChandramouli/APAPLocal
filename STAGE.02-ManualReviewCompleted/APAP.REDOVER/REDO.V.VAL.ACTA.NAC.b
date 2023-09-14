* @ValidationCode : MjotNTk3MTU5NDczOkNwMTI1MjoxNjgxMzcyMTc1Mzg0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 13:19:35
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.ACTA.NAC
*-------------------------------------------------------------------------------
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : NARESH.CHAVADAPU(nareshc@temenos.com)
*Date              : 28-10-2009
*Program   Name    : REDO.V.VAL.ACTA.NAC
*Reference Number  : ODR-2009-10-0807
*-----------------------------------------------------------------------------------------------------------------
*Description       : This routine serves as a field level validation for the field l.cu.actanac***
*Linked With       : NA
*In  Parameter     : NA
*Out Parameter     : NA
*------insert files-----------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*13-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*13-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

    GOSUB PROCESS
RETURN

*---------
PROCESS:
*----------------------------------------------------------------------------------
* The local field value is checked for its length and error is thrown based on it
*-----------------------------------------------------------------------------------

    Y.TEMP.VAR=COMI
    Y.COUNT.VAR=LEN(Y.TEMP.VAR)
    LOC.REF.APPLICATION = 'CUSTOMER'
    LOC.REF.FIELDS='L.CU.ACTANAC'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.ACTANAC = LOC.REF.POS<1,1>
    IF Y.TEMP.VAR NE '' THEN
        IF Y.COUNT.VAR NE 20 THEN
            AF = EB.CUS.LOCAL.REF
            AV = POS.ACTANAC
            ETEXT='EB-REDO.INVALID.DOC.FORMAT'
            CALL STORE.END.ERROR
        END
    END
RETURN
*----------------------------------------------------------------------------
END

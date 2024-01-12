* @ValidationCode : Mjo2NTk0NTIyNTc6Q3AxMjUyOjE3MDM3MzY2MjY1MDk6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Dec 2023 09:40:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.AUT.DEL.BEN
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.AUT.DEL.BEN
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine used to delete the beneficiaries
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference                       Description
* 28-Dec-2010        Prabhu.N       ODR-2010-08-0031              Initial Creation
*06-04-2023       Conversion Tool    R22 Auto Code conversion         IF CONDITION ADDED
*06-04-2023       Samaran T          R22 Manual Code Conversion        No Changes
* 28-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_System

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*---------
OPEN.PARA:
*---------
    FN.CUS.BEN.LIST = 'F.CUS.BEN.LIST'
    F.CUS.BEN.LIST  = ''
    CALL OPF(FN.CUS.BEN.LIST,F.CUS.BEN.LIST)
RETURN

*------------
PROCESS.PARA:
*------------

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 AUTO CODE CONVERSION
        CUSTOMER.ID = ""  ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION

    IF PGM.VERSION EQ ',ADD.OWN.BANK.BEN.DE' OR PGM.VERSION EQ ',ADD.OWN.BANK.BEN.DE.CONFIRM' THEN

        GOSUB DEL.BEN.OWN
    END

    IF PGM.VERSION EQ ',ADD.OTHER.BANK.BEN.DE' OR PGM.VERSION EQ ',ADD.OTHER.BANK.BEN.DE.CONFIRM' THEN
        GOSUB DEL.BEN.OTHER
    END

RETURN
*-----------
DEL.BEN.OWN:
*-----------
    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OWN'
* CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    CALL F.READU(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER,'');*R22 MANUAL CODE CONVERSION

    LOCATE R.NEW(ARC.BEN.BEN.ACCT.NO) IN R.CUS.BEN.LIST<1> SETTING Y.BEN.POS THEN
        DEL R.CUS.BEN.LIST<Y.BEN.POS>
    END

    CALL F.WRITE(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST)

RETURN
*-------------
DEL.BEN.OTHER:
*-------------
    CUS.BEN.LIST.ID = CUSTOMER.ID:'-OTHER'
* CALL F.READ(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER)
    CALL F.READU(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST,F.CUS.BEN.LIST,CUS.BEN.LIST.ER,'');*R22 MANUAL CODE CONVERSION
    
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF('BENEFICIARY','L.BEN.ACCOUNT',FLD.POS)
    LOCATE R.NEW(ARC.BEN.LOCAL.REF)<1,FLD.POS> IN R.CUS.BEN.LIST<1> SETTING Y.BEN.POS THEN
        DEL R.CUS.BEN.LIST<Y.BEN.POS>
    END

    CALL F.WRITE(FN.CUS.BEN.LIST,CUS.BEN.LIST.ID,R.CUS.BEN.LIST)

RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------

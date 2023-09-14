* @ValidationCode : MjotMTYwMzgwODkxMTpDcDEyNTI6MTY4MTEyODYxNDM5ODpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 17:40:14
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
SUBROUTINE REDO.V.CHK.IDENTITY.TYPE
*--------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Shankar Raju
* PROGRAM NAME : REDO.CHK.CUSTOMER.TYPE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------------------------------
* Date             Author     Reference         Description
*
* 11-10-2011      Sudhar     teller issue  Making PASSPORT.COUNTRY field as non-inputable field
*                                                  to achieve the if Client is other than Passport.
*-----------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*10-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*10-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.ID.CARD.CHECK

    GOSUB MAKE.NO.INPUT

RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
MAKE.NO.INPUT:
*-------------

    IF (OFS$HOT.FIELD EQ 'IDENTITY.TYPE') OR (OFS$HOT.FIELD EQ '.IDENTITY.TYPE') THEN
        VAR.ID.TYPE = COMI
    END ELSE
        VAR.ID.TYPE = R.NEW(REDO.CUS.PRF.IDENTITY.TYPE)
    END

    IF VAR.ID.TYPE EQ 'PASAPORTE' THEN
        T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = ''
    END ELSE
        R.NEW(REDO.CUS.PRF.PASSPORT.COUNTRY) = ''
        T(REDO.CUS.PRF.PASSPORT.COUNTRY)<3> = 'NOINPUT'
    END

RETURN
*---------------------------------------------------------------------------------------------------------------------------------------------------
END

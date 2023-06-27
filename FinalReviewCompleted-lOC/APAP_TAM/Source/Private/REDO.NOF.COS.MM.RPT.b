* @ValidationCode : MjotNzA4MzcyOTk6Q3AxMjUyOjE2ODQ0OTEwMzY3NzI6SVRTUzotMTotMTotNjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.NOF.COS.MM.RPT(Y.DATE)
*-----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : MANJU.G
*  ODR Number        : ODR-2010-08-0431
*  Program   Name    : REDO.NOF.COS.MM.RPT
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report that shows
*                     all insurance daily entries report
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE            DESCRIPTION
*  -----           ----            ----------           -----------
*  11-Nov-2010     MANJU.G       ODR-2010-03-0140     INITIAL CREATION
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB INIT
RETURN

INIT:
*----------
    Y.DATE = ''
    Y.CURRENCY = ''

    LOCATE "DATE" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.DATE = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.CURRENCY  = D.RANGE.AND.VALUE<Y.POS>
    END

    Y.DATE = Y.SEL.DATE:'*':Y.CURRENCY:'*':"View"
RETURN
END

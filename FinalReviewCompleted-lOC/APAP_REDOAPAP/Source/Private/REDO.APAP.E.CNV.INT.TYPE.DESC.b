* @ValidationCode : MjoyMDU1NTA5NzU2OkNwMTI1MjoxNjgwNjcyOTAwNzAyOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:05:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.CNV.INT.TYPE.DESC
*----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : Krishna Murthy T.S
*  ODR Number        : ODR-2010-08-0424
*  Program   Name    : REDO.APAP.E.CNV.INT.TYPE.DESC
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       :This is a conversion routine enquiry which will fetch the
*                    description for the INTEREST.TYPE value entered
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO                  REFERENCE            DESCRIPTION
*  23-Mar-2011     Krishna Murthy T.S   PACS00037719         Initial Creation
* Date                  who                   Reference              
* 05-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 05-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON

    Y.DATA = O.DATA
    BEGIN CASE
        CASE Y.DATA EQ 1
            O.DATA = "FIXED"
        CASE Y.DATA EQ 3
            O.DATA = "FLOATING"
        CASE Y.DATA EQ 9
            O.DATA = "NONE"
    END CASE
RETURN
END

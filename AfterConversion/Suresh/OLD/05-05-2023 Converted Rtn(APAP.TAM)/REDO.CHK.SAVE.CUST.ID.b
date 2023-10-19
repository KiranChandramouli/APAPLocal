* @ValidationCode : MjoxODk3ODU4MjI6Q3AxMjUyOjE2ODA2OTAzNjIzNjc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:56:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CHK.SAVE.CUST.ID
*---------------------------------------------------------------------------------
* This is a CHECK.REC.RTN to save the Customer id in a common variable.
*----------------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : SHANKAR RAJU
* Program Name  : REDO.CHK.SAVE.CUST.ID
* ODR NUMBER    : ODR-2009-10-0315
* HD Reference  : PACS00092771
*----------------------------------------------------------------------
*MODIFICATION DETAILS:
*   DATE            DEVELOPER          REFERENCE            DESCRIPTION
* 30-JULY-2011    GANESH HARIDAS     PACS00092771 - B.29   Save a ID to a Common variable
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*05/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*05/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------
PROCESS:
*-------

    CALL System.setVariable("CURRENT.AZ.ID.REF",ID.NEW)

RETURN
END

* @ValidationCode : MjotNjE3NjI2OTQ3OkNwMTI1MjoxNjgwNjA3MTMzOTU0OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.MSG.FORMAT(INTERFACE.ID,DATO.IN,DATO.OUT)
******************************************************************************
*
* Subroutine Type : Formatting Routine
* Attached to     : Programs for Flat Interface Funcionality
* Attached as     : Subroutine
* Primary Purpose : To return formatted data to the calling Program
*
* Incoming:
* ---------
*
* INTERFACE.ID  -  ID of RAD.CONDUIT.LINEAR record to be used for formatting
* DATO.IN       -  Input Message to be formatted
*
* Outgoing:
* ---------
* DATO.OUT      - fORMATTED RECORD TO BE RETURNED TO THE CALLING PROGRAM
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : JOAQUIN cOSTA - TAM Latin America
* Date            : Oct 26, 2010

*  DATE             WHO                   REFERENCE 
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - No changes
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
*************************************************************************
*


    MAP.FMT  = "MAP"
    ID.RCL   = INTERFACE.ID
    APP      = ""
    ID.APP   = ""
    R.INPUT  = DATO.IN
    R.OUTPUT = ""
    WERR.MSG = ""
    DATO.OUT = ""



    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT, ID.RCL, APP, ID.APP, R.INPUT, R.OUTPUT, WERR.MSG)

    DATO.OUT = R.OUTPUT

RETURN
*

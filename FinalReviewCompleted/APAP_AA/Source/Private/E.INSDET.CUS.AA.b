* @ValidationCode : MjotMzAzNDgzMDEzOkNwMTI1MjoxNjgzODc3OTY3MzY2OklUU1M6LTE6LTE6NzY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 May 2023 13:22:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 76
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA ;*R22 Manual Code Conversion
SUBROUTINE E.INSDET.CUS.AA(ENQ.DATA)
*
*
*=====================================================================
* Subroutine Type : NOFILE ROUTINE
* Attached to     :
* Attached as     :
* Primary Purpose :
*---------------------------------------------------------------------
* Modification History:
*
* Date                  Who                               Reference                       Description
* ----                  ----                                ----                                ----
* 29-March-2023       Conversion Tool            R22 Auto Code Conversion                No Change
* 29-March-2023          Ajith Kumar             R22 Manual Code Conversion              Package Name added APAP.AA, CALL method format changed


* Development for : APAP
* Development by  : cherrera
* Date            : 2011-08-01
*=====================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*
************************************************************************
*

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB PROCESS.GOAHEAD

************************************************************************

INITIALISE:
    CUST.LIST = ""
    AA.LIST = ""

RETURN

***********************************************************************

OPENFILES:

RETURN

************************************************************************

PROCESS.GOAHEAD:
* FIND THE CUSTOMER DATA IN ENQUIRY.DATA
    LOCATE 'INS.DET.CUSTOMER' IN ENQ.DATA<2,1> SETTING Y.POS ELSE NULL

* GET CUSTOMER LIST FROM ENQ.DATA
    CUST.LIST = ENQ.DATA<4,Y.POS>


* CALL THE APAP.CUS.AA.ARRANGEMENT TO BUILD AA.LIST
*APAP.CUS.AA.ARRANGEMENT(CUST.LIST,AA.LIST)
    APAP.AA.apapCusAaArrangement(CUST.LIST,AA.LIST) ;*R22 Manual Code Conversion

RETURN

************************************************************************

END

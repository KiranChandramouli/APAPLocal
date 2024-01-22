* @ValidationCode : MjoxMTkxOTg2NTY6Q3AxMjUyOjE3MDQ0NDAwNDM4Mzk6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 13:04:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.S.FC.AA.OWNER(AA.ID, AA.ARR)
    
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.CUSTOMER>OWNER  FIELD
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
* Date              Who           Reference                       DESCRIPTION
*05-01-2024      VIGNESHWARI S   R22 Manual Code Conversion         CALL RTN IS MODIFIED
*---------------------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.CUSTOMER
   $USING AA.Framework

GOSUB INITIALISE
GOSUB OPEN.FILES

IF PROCESS.GOAHEAD THEN
GOSUB PROCESS
END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
AA.Framework.GetArrangementConditions(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR);* R22 AUTO CONVERSION
*AA.ARR = INT.COND<AA.CUS.OWNER>       ;* This hold the Value in the core field
AA.ARR = INT.COND<AA.CUS.CUSTOMER> ;* R22 Manual conversion
RETURN
*------------------------
INITIALISE:
*=========
PROCESS.GOAHEAD = 1
Y.ARRG.ID = AA.ID
PROPERTY.CLASS = 'CUSTOMER'
AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END

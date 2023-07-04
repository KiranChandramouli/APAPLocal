* @ValidationCode : MjotMTU0NTM4NjQzMDpDcDEyNTI6MTY4MTEzMjc2NzY1MzpJVFNTOi0xOi0xOi04OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 18:49:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -8
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE CERTIFIED.CHEQUE.PARAMETER.RECORD
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* DESCRIPTION :  This is routine is needed to automatically populate
* the field TAX.KEY in the template CERTIFIED.CHEQUE.PARAMETER
*----------------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*--------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : CERTIFIED.CHEQUE.PARAMETER
*----------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 09.02.2011      SUDHARSANAN S       HD1048577        Initialised the tax key value as per the issue
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
* ---------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------
PROCESS:
*Update Tax.Key value for Government and Non.Government cheque in CERTIFIED.CHEQUE.PARAMETER table
    R.NEW(CERT.CHEQ.TAX.KEY)<1,1> = 'IMP015%'
    R.NEW(CERT.CHEQ.TAX.KEY)<1,2> = 'IMP015%'
RETURN
*------------------------------------------------------------------------------
END

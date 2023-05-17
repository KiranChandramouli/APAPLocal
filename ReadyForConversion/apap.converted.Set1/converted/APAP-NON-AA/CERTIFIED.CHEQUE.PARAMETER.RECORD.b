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

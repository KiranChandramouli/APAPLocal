*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.V.AUTH.REV.CHEQ
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at the Authorisation level for the Following
* versions of TELLER, REVERSE.CERTIFIED.CHEQUES. This Routine will be used for reversing the
* Certified Cheques and also it will update the Status of the Cheque number to CANCELLED in
* the tables CERTIFIED.CHEQUE.STOCK and CERTIFIED.CHEQUE.DETAILS
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* ---------------------------
* IN : -NA-
* OUT : -NA-
* Linked With : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.AUTH.REV.CHEQ
*------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------
* DATE WHO REFERENCE DESCRIPTION
* 16.03.2010 SUDHARSANAN S ODR-2009-10-0319 INITIAL CREATION
* ----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.TELLER
$INSERT I_F.CERTIFIED.CHEQUE.STOCK
$INSERT I_F.CERTIFIED.CHEQUE.DETAILS
GOSUB INIT
GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
INIT:
FN.CERTIFIED.CHEQUE.STOCK='F.CERTIFIED.CHEQUE.STOCK'
F.CERTIFIED.CHEQUE.STOCK=''
CALL OPF(FN.CERTIFIED.CHEQUE.STOCK,F.CERTIFIED.CHEQUE.STOCK)
FN.CERTIFIED.CHEQUE.DETAILS='F.CERTIFIED.CHEQUE.DETAILS'
F.CERTIFIED.CHEQUE.DETAILS=''
CALL OPF(FN.CERTIFIED.CHEQUE.DETAILS,F.CERTIFIED.CHEQUE.DETAILS)
LREF.APP='TELLER'
LREF.FIELD='CERT.CHEQUE.NO'
LREF.POS=''
CALL GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*Update CERTIFIED.CHEQUE.STOCK and CERTIFIED.CHEQUE.DETAILS Tables
Y.CERT.CHEQ.NO = R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS>
CALL F.READ(FN.CERTIFIED.CHEQUE.STOCK,Y.CERT.CHEQ.NO,R.CERT.CHEQ.STO,F.CERTIFIED.CHEQUE.STOCK,STO.ERR)
R.CERT.CHEQ.STO<CERT.STO.STATUS> = 'CANCELLED'
CALL F.WRITE(FN.CERTIFIED.CHEQUE.STOCK,Y.CERT.CHEQ.NO,R.CERT.CHEQ.STO)
CALL F.READ(FN.CERTIFIED.CHEQUE.DETAILS,Y.CERT.CHEQ.NO,R.CERT.CHEQ.DET,F.CERTIFIED.CHEQUE.DETAILS,DET.ERR)
R.CERT.CHEQ.DET<CERT.DET.STATUS> = 'CANCELLED'
CALL F.LIVE.WRITE(FN.CERTIFIED.CHEQUE.DETAILS,Y.CERT.CHEQ.NO,R.CERT.CHEQ.DET)
RETURN
*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
END
*------------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CHANGE.CHEQ.STATUS.LOAD
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.CHANGE.CHEQ.STATUS.LOAD
*----------------------------------------------------------
* DESCRIPTION : It will be required to create REDO.CHANGE.CHEQ.STATUS.LOAD
* as a LOAD routine for BATCH

*------------------------------------------------------------

* LINKED WITH : REDO.CHANGE.CHEQ.STATUS
* IN PARAMETER: NONE
* OUT PARAMETER: NONE

* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*03.04.2010 HARISH.Y ODR-2009-12-0275 INITIAL CREATION

*-------------------------------------------------------------
*-------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CHEQUE.ISSUE
$INSERT I_F.REDO.H.SOLICITUD.CK
$INSERT I_F.REDO.H.CHEQ.CHANGE.PARAM
$INSERT I_REDO.CHANGE.CHEQ.STATUS.COMMON


GOSUB INIT
RETURN

*-------------------------------------------------------------
INIT:
*-------------------------------------------------------------
FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
F.REDO.H.SOLICITUD.CK = ''
CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

FN.CHEQUE.ISSUE = 'F.CHEQUE.ISSUE'
F.CHEQUE.ISSUE = ''
CALL OPF(FN.CHEQUE.ISSUE,F.CHEQUE.ISSUE)

FN.REDO.H.CHEQ.CHANGE.PARAM = 'F.REDO.H.CHEQ.CHANGE.PARAM'
F.REDO.H.CHEQ.CHANGE.PARAM = ''
CALL OPF(FN.REDO.H.CHEQ.CHANGE.PARAM,F.REDO.H.CHEQ.CHANGE.PARAM)

FN.CHEQUE.REGISTER = 'F.CHEQUE.REGISTER'
F.CHEQUE.REGISTER = ''
CALL OPF(FN.CHEQUE.REGISTER,F.CHEQUE.REGISTER)

FN.REDO.CONCAT.CHEQUE.REGISTER = 'F.REDO.CONCAT.CHEQUE.REGISTER'
F.REDO.CONCAT.CHEQUE.REGISTER = ''
CALL OPF(FN.REDO.CONCAT.CHEQUE.REGISTER,F.REDO.CONCAT.CHEQUE.REGISTER)

OFS.ARRAY=''

LOC.REF.APPLICATION="CHEQUE.ISSUE"
LOC.REF.FIELDS='L.SOLICITUDCKID'
LOC.REF.POS=''
CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)


POS.L.SOLICITUDCKID=LOC.REF.POS<1,1>


RETURN


*-------------------------------------------------------------------
END

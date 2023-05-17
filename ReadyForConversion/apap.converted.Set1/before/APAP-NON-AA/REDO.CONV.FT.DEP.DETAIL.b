*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CONV.FT.DEP.DETAIL
*---------------------------------------------------
* Description: This is conversion routine to display the Deposit Description in enquiry.
*--------------------------------------------------------------------------------
* Modification History:
* Date Reference Who Description
* 24 Jan 2012 PACS00175283 -N.45 H GANESH INITIAL DRAFT
*--------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_ENQUIRY.COMMON

GOSUB OPENFILES
GOSUB PROCESS
RETURN
*----------------------------------------------------
OPENFILES:
*----------------------------------------------------

FN.FT = 'F.FUNDS.TRANSFER'
F.FT = ''
CALL OPF(FN.FT,F.FT)

FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
F.FT.HIS = ''
CALL OPF(FN.FT.HIS,F.FT.HIS)

LOC.REF.APPLICATION="FUNDS.TRANSFER"
LOC.REF.FIELDS='L.FT.MSG.DESC'
LOC.REF.POS=''
CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
POS.L.FT.MSG.DESC = LOC.REF.POS<1,1>

RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

Y.FT.ID = O.DATA
FT.ERR = ''
CALL F.READ(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
IF FT.ERR THEN
CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.FT.ID,R.FT,YERR)
END
Y.DEP.DETAILS = R.FT<FT.LOCAL.REF,POS.L.FT.MSG.DESC>
CHANGE SM TO VM IN Y.DEP.DETAILS
O.DATA = Y.DEP.DETAILS

RETURN
END

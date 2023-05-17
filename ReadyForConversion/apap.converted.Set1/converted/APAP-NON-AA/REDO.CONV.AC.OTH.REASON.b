SUBROUTINE REDO.CONV.AC.OTH.REASON
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the descriptions
*------------------------------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.ACCOUNT

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

***********
OPEN.FILES:
***********

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT.HIS = ''
    CALL OPF(FN.ACCOUNT.HIS,F.ACCOUNT.HIS)

    Y.APPL = 'ACCOUNT'
    Y.FIELDS = 'L.AC.CAN.REASON'::@VM:'L.AC.OTH.REASON'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS)
    Y.L.AC.CAN.REASON.POS  = Y.POS<1,1>
    Y.L.AC.OTH.REASON.POS  = Y.POS<1,2>
RETURN
**********
PROCESS:
*********


    Y.ID  = FIELD(O.DATA,'\',1)
    CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF NOT(R.ACCOUNT) THEN
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ID,R.ACCOUNT,YERR)
    END
    VAR.OTH.REASON = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.OTH.REASON.POS>
    CHANGE @SM TO @FM IN VAR.OTH.REASON
    MULTI.DATA = VAR.OTH.REASON
    IF VC EQ 1 THEN
        VM.COUNT = DCOUNT(MULTI.DATA,@FM)
        O.DATA = MULTI.DATA<VC>
    END ELSE
        O.DATA = MULTI.DATA<VC>
    END
RETURN
*-------------------------------------------------------------------------------------------------------------------
END

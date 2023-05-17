*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.AC.CAN.REASON
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
  Y.FIELDS = 'L.AC.CAN.REASON'::VM:'L.AC.OTH.REASON'
  Y.POS = ''
  CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS)
  Y.L.AC.CAN.REASON.POS  = Y.POS<1,1>
  Y.L.AC.OTH.REASON.POS  = Y.POS<1,2>
  RETURN
**********
PROCESS:
*********
  MULTI.DATA  = ''

  VAR.USER.LANG  =  R.USER<EB.USE.LANGUAGE>
  VAR.VIRTUAL.TABLE = "L.AC.CAN.REASON"
  CALL EB.LOOKUP.LIST(VAR.VIRTUAL.TABLE)
  CNT.VTABLE= DCOUNT(VAR.VIRTUAL.TABLE,FM)
  VIRTUAL.TABLE.IDS = VAR.VIRTUAL.TABLE<2>        ;*2nd Part
  VIRTUAL.TABLE.VALUES = VAR.VIRTUAL.TABLE<CNT.VTABLE>
  CHANGE '_' TO FM IN VIRTUAL.TABLE.VALUES
  CHANGE '_' TO FM IN VIRTUAL.TABLE.IDS

  Y.ID  = FIELD(O.DATA,'\',1)
  CALL F.READ(FN.ACCOUNT,Y.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF NOT(R.ACCOUNT) THEN
    CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIS,Y.ID,R.ACCOUNT,YERR)
  END
  VAR.CAN.REASON = R.ACCOUNT<AC.LOCAL.REF,Y.L.AC.CAN.REASON.POS>
  CHANGE SM TO FM IN VAR.CAN.REASON
  FM.CNT = DCOUNT(VAR.CAN.REASON,FM)  ; Y.CNT = 1
  LOOP
  WHILE Y.CNT LE FM.CNT
    OUT.DATA = VAR.CAN.REASON<Y.CNT>
    LOCATE OUT.DATA IN VIRTUAL.TABLE.IDS SETTING POS THEN
      VAL.LIST.REST = ''
      VAL.LIST.REST = VIRTUAL.TABLE.VALUES<POS,VAR.USER.LANG>
      IF NOT(VAL.LIST.REST) THEN
        MULTI.DATA<-1> = VIRTUAL.TABLE.VALUES<POS,1>
      END ELSE
        MULTI.DATA<-1> = VAL.LIST.REST
      END
    END
    Y.CNT++
  REPEAT
  IF VC EQ 1 THEN
    VM.COUNT = DCOUNT(MULTI.DATA,FM)
    O.DATA = MULTI.DATA<VC>
  END ELSE
    O.DATA = MULTI.DATA<VC>
  END

  RETURN
*-------------------------------------------------------------------------------------------------------------------
END

*-----------------------------------------------------------------------------
* <Rating>-77</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.LINE.STATUS.CREATE

*This input routine is used to check the values for account status and loan status
*in line. Routine is developed assuming that CPL is setup as below. In future if CPL
*position is changed this routine needs to ammended accordingly

*       PROFIT1  =  PLCATEGORY
*       PROFIT2  =  PLPRODUCT
*       PROFIT3  =  PLSECTOR
*       PROFIT4  =  PLODUE.STATU
*       PROFIT5  =  PLCONDLOAN
*       PROFIT6  =  PLSCBOOK
*       PROFIT7  =  PLACSTATUS
*       PROFIT8  =
*       PROFIT9  =
*       PROFIT10 =
*       PROFIT11 =

*----------------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
*----------------------------------------------------------------------------------------------------------------------
* Date             Author            Reference                   Description
* 10-jun-2011      Gurudev           PACS00037709                CHECK VALIDATION FOR PL.AC.STATUS AND PL.LOAN.STATUS
* 25-Jun-2011      Pradeep S         PACS00072689                New section to check AL/PL application id
* 25-Jun-2011      Pradeep S         PACS00037709                Correct position is checked based on the CPL setup
* 06-Oct-2011      Pradeep S         PACS00140800                CUR and DUE added for over due status validations
* 28-Oct-2011      Pradeep S         PACS00151763                PG added for PLACSTATUS validations
*-----------------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.RE.STAT.REP.LINE
*----*
MAIN:
*----*

  GOSUB VIRTUAL.TAB.ID
  GOSUB CHECK.AL.PL.APPL.ID

  RETURN
*-------------*
VIRTUAL.TAB.ID:
*-------------*

  VAR.VIRTUAL.TABLE=''

*PACS00037709 - S
  PL.AC.STATUS=R.NEW(RE.SRL.PROFIT7)
  PL.LOAN.STATUS = R.NEW(RE.SRL.PROFIT4)
*PACS00037709 - E

  EB.LOOKUP.1='L.AC.STATUS1'
  CALL EB.LOOKUP.LIST(EB.LOOKUP.1)
  VIRTUAL.AC1.STATS = EB.LOOKUP.1<2>
  CHANGE '_' TO FM IN VIRTUAL.AC1.STATS


  EB.LOOKUP.2='L.AC.STATUS2'
  CALL EB.LOOKUP.LIST(EB.LOOKUP.2)
  VIRTUAL.AC2.STATS = EB.LOOKUP.2<2>
  CHANGE '_' TO FM IN VIRTUAL.AC2.STATS
  FINAL.AC.STATUS=VIRTUAL.AC1.STATS:FM:VIRTUAL.AC2.STATS

  EB.LOOKUP.3='AA.OVERDUE.STATUS'
  CALL EB.LOOKUP.LIST(EB.LOOKUP.3)
  VIRTUAL.ODUE.STATS = EB.LOOKUP.3<2>
  CHANGE '_' TO FM IN VIRTUAL.ODUE.STATS

  GOSUB PROCESS.AC.STATUS
  GOSUB PROCESS.LOAN.STATUS

  RETURN

PROCESS.AC.STATUS:
*******************

  FINAL.AC.STATUS = FINAL.AC.STATUS:FM:"PG"       ;*PACS00151763 - S/E

  Y.AC.CNT = ''
  LOOP
    REMOVE Y.PL.AC.VAL FROM PL.AC.STATUS SETTING AC.POS
  WHILE Y.PL.AC.VAL:AC.POS
    Y.AC.CNT = Y.AC.CNT + 1
    IF Y.PL.AC.VAL THEN
      LOCATE Y.PL.AC.VAL IN FINAL.AC.STATUS SETTING STAT.POS ELSE
        ETEXT = "EB-CANT.CHANGED"
        AF = RE.SRL.PROFIT7
        AV = Y.AC.CNT
        CALL STORE.END.ERROR
      END
    END

  REPEAT

  RETURN

PROCESS.LOAN.STATUS:
*********************
  VIRTUAL.ODUE.STATS = VIRTUAL.ODUE.STATS:FM:"CUR":FM:"DUE" ;*PACS00140800 - S/E

  Y.PL.CNT = ''
  LOOP
    REMOVE Y.PL.LOAN.VAL FROM PL.LOAN.STATUS SETTING LN.POS
  WHILE Y.PL.LOAN.VAL:LN.POS
    Y.PL.CNT = Y.PL.CNT + 1
    IF Y.PL.LOAN.VAL THEN
      LOCATE Y.PL.LOAN.VAL IN VIRTUAL.ODUE.STATS SETTING STAT.POS ELSE
        ETEXT = "EB-CANT.CHANGED"
        AF = RE.SRL.PROFIT4
        AV = Y.PL.CNT
        CALL STORE.END.ERROR
      END
    END
  REPEAT

  RETURN

CHECK.AL.PL.APPL.ID:
*********************
*PACS00072689 - New section to check AL/PL application id

  Y.AL.APPL.ID = R.NEW(RE.SRL.ASSET.APPLIC.ID)
  Y.PL.APPL.ID = R.NEW(RE.SRL.PROFT.APPLIC.ID)

  IF Y.AL.APPL.ID NE '' AND Y.PL.APPL.ID NE '' THEN
    ETEXT = "RE-REDO.LINE.APPLIC.ID"
    AF = RE.SRL.PROFT.APPLIC.ID
    CALL STORE.END.ERROR
  END

  RETURN
END

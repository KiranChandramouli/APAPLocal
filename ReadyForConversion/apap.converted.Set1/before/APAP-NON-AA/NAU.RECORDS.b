*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  PROGRAM NAU.RECORDS

$INSERT I_COMMON
$INSERT I_EQUATE

  OPEN "TAM.BP" TO F.TEST THEN
    K = 1
  END

  READ SEL.CMDS FROM F.TEST,"NAU.APPS" THEN
    SEL.CMDS = SORT(SEL.CMDS)
    SEL.CMD.CNT = DCOUNT(SEL.CMDS,FM)

    SEL.LIST = ''

    LOOP
      REMOVE SEL.ID FROM SEL.CMDS SETTING POS
    WHILE SEL.ID:POS
      SEL.CMD = 'SELECT ':SEL.ID:'$NAU'
      SEL.TEMP.LIST = ''
      CALL EB.READLIST(SEL.CMD,SEL.TEMP.LIST,'',NR.CNT,'')
      FOR I = 1 TO NR.CNT
        SEL.LIST<-1> = SEL.ID:"NAU>>":SEL.TEMP.LIST<I>
      NEXT I
    REPEAT

    CRT " S T A G E  (1. Before Upgrade / 2. After Upgrade / 3. Final ) : "
    INPUT ANS

    IF ANS EQ '' THEN
      ANS = "TEST"
    END

    WRITE SEL.LIST TO F.TEST, "NAU.RECORDS.":ANS:".UPGRADE" ON ERROR
      CRT "WRITE FAILS"
    END

  END

  RETURN
END

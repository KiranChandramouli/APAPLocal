PROGRAM REDO.XREF.CORRECTION
*---------------------------------------------------------
*Description: This correction program is to correct the corrupted
* AA.ARRANGEMENT.DATED.XREF file.
*---------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.ACTIVITY.HISTORY


    EXECUTE "COMO ON REDO.XREF.CORRECTION"
    GOSUB OPEN.REQ.FILES        ;* Open required files

    CALL OCOMO("**Initializing the correction process**")
    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    CALL OCOMO("**No of arrangements selected - ":SEL.NOR)

    GOSUB PROCESS.XREF          ;* Main process begins here.
    CALL OCOMO("!!! Correction Process completed !!!")
    EXECUTE "COMO OFF REDO.XREF.CORRECTION"
RETURN

*---------------------------------------------------------
PROCESS.XREF:
*---------------------------------------------------------
* Main process begins here.

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE SEL.NOR
        Y.AA.ID = SEL.LIST<Y.VAR1>
        CALL OCOMO("**Processing the arrangement - ":Y.AA.ID: " - ":Y.VAR1:"/":SEL.NOR)
        CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,Y.AA.ID,R.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF,XREF.ERR)
        Y.UPDATE.FLAG = ''

        IF R.AA.ARRANGEMENT.DATED.XREF THEN
            GOSUB CHECK.XREF.INAU
        END ELSE
            CALL OCOMO("**XREF not found for arrangement - ":Y.AA.ID)
            Y.ERROR.IDS<-1> = Y.AA.ID:" - XREF record is missing."
        END
        IF Y.UPDATE.FLAG EQ 'YES' THEN
            CALL F.WRITE(FN.AA.ARRANGEMENT.DATED.XREF,Y.AA.ID,R.AA.ARRANGEMENT.DATED.XREF)
            CALL OCOMO("Correction done -":Y.AA.ID)
            Y.CORRECTED.IDS<-1> = Y.AA.ID
        END

        IF MOD(Y.VAR1,500) EQ 0 THEN
            CALL JOURNAL.UPDATE("")
        END

        Y.VAR1 += 1
    REPEAT

* Log files updated in &COMO&

    OPEN '','&COMO&' TO F.COMO THEN

        WRITE Y.ERROR.IDS TO F.COMO,'REDO.ERROR.IDS'  ;* Records with read errors.

        WRITE Y.CORRECTED.IDS  TO F.COMO,'REDO.CORRECTED.IDS'   ;* Records which are corrected.

        WRITE Y.REVIEW.IDS TO F.COMO,'REDO.REVIEW.IDS'          ;* Records which needs manual review.

        WRITE Y.NO.INAU.IDS TO F.COMO,'REDO.INAU.IDS' ;* Records which doesnt have INAU records in XREF.

        WRITE Y.REAL.INAU.RECORD TO F.COMO,'REDO.REAL.INAU.IDS' ;* Records which are having INAU activities.

    END ELSE
        CALL OCOMO("$$$$REDO.ERROR.IDS - START $$$")
        CALL OCOMO(Y.ERROR.IDS)
        CALL OCOMO("$$$$REDO.ERROR.IDS - END $$$")

        CALL OCOMO("$$$$ REDO.CORRECTED.IDS - START $$$")
        CALL OCOMO(Y.CORRECTED.IDS)
        CALL OCOMO("$$$$ REDO.CORRECTED.IDS - END $$$")

        CALL OCOMO("$$$$ REDO.REVIEW.IDS - START $$$")
        CALL OCOMO(Y.REVIEW.IDS)
        CALL OCOMO("$$$$ REDO.REVIEW.IDS - END $$$")

        CALL OCOMO("$$$$ REDO.INAU.IDS - START $$$")
        CALL OCOMO(Y.NO.INAU.IDS)
        CALL OCOMO("$$$$ REDO.INAU.IDS - END $$$")

        CALL OCOMO("$$$$ REDO.REAL.INAU.IDS - START $$$")
        CALL OCOMO(Y.REAL.INAU.RECORD)
        CALL OCOMO("$$$$ REDO.REAL.INAU.IDS - END $$$")
    END


RETURN
*---------------------------------------------------------
CHECK.XREF.INAU:
*---------------------------------------------------------
* Here we check whether R.AA.ARRANGEMENT.DATED.XREF<3> has any dated record then we will do correction process

    IF SUM(R.AA.ARRANGEMENT.DATED.XREF<3>) ELSE
        CALL OCOMO("No INAU records for the AA - ":Y.AA.ID)
        Y.NO.INAU.IDS<-1> = Y.AA.ID
        RETURN
    END

    Y.INAU.DATES.CNT = DCOUNT(R.AA.ARRANGEMENT.DATED.XREF<3>,@VM)

    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.INAU.DATES.CNT
        IF R.AA.ARRANGEMENT.DATED.XREF<3,Y.VAR2> NE '' THEN
            Y.VAR3 = 1
            Y.DATES = R.AA.ARRANGEMENT.DATED.XREF<3,Y.VAR2>
            Y.DATES.CNT = DCOUNT(Y.DATES,@SM)
            LOOP
            WHILE Y.VAR3 LE Y.DATES.CNT
                Y.INAU.DATE     = R.AA.ARRANGEMENT.DATED.XREF<3,Y.VAR2,Y.VAR3>
                Y.INAU.PROPERTY = R.AA.ARRANGEMENT.DATED.XREF<1,Y.VAR2>
                CALL CACHE.READ(FN.AA.PROPERTY, Y.INAU.PROPERTY, R.AA.PROPERTY, PROP.ERR)
                IF PROP.ERR THEN
                    Y.ERROR.IDS<-1> = Y.AA.ID:" - INAU property is missing - ":Y.INAU.PROPERTY
                    BREAK
                END
                FN.FILE.NAME = "F.AA.ARR.":R.AA.PROPERTY<AA.PROP.PROPERTY.CLASS>
                F.FILE.NAME  = ''
                CALL OPF(FN.FILE.NAME,F.FILE.NAME)

                FN.FILE.NAME$NAU = "F.AA.ARR.":R.AA.PROPERTY<AA.PROP.PROPERTY.CLASS>:"$NAU"
                F.FILE.NAME$NAU  = ''
                CALL OPF(FN.FILE.NAME$NAU,F.FILE.NAME$NAU)

                Y.AA.ARR.ID = Y.AA.ID:"-":Y.INAU.PROPERTY:"-":Y.INAU.DATE
                CALL F.READ(FN.FILE.NAME,Y.AA.ARR.ID,R.AA.ARR.LIVE,F.FILE.NAME,FILE.ERR)
                CALL F.READ(FN.FILE.NAME$NAU,Y.AA.ARR.ID,R.AA.ARR.INAU,F.FILE.NAME$NAU,FILE.NAU.ERR)
                IF R.AA.ARR.LIVE AND R.AA.ARR.INAU EQ '' THEN
                    GOSUB CHECK.AAA.INAU
                    IF Y.AAA.STATUS EQ 'AUTH' THEN
                        R.AA.ARRANGEMENT.DATED.XREF<3,Y.VAR2,Y.VAR3> = ''
                        Y.UPDATE.FLAG = 'YES'
                    END ELSE
                        Y.REVIEW.IDS<-1> = "Review these IDS - ":Y.AA.ARR.ID
                        BREAK
                    END
                END ELSE
                    IF R.AA.ARR.LIVE EQ '' AND R.AA.ARR.INAU NE '' THEN
                        CALL OCOMO("Record is not in live ":Y.AA.ARR.ID)
                        Y.REAL.INAU.RECORD<-1> = Y.AA.ID:" - ":"Record is not in live"
                    END
                    IF R.AA.ARR.LIVE EQ '' AND R.AA.ARR.INAU EQ '' THEN
                        CALL OCOMO("Record is not in both live and INAU":Y.AA.ARR.ID)
                        Y.REAL.INAU.RECORD<-1> = Y.AA.ID:" - ":"Record is not in both live and INAU"
                    END
                    IF R.AA.ARR.LIVE NE '' AND R.AA.ARR.INAU NE '' THEN
                        CALL OCOMO("Record is not in both live and INAU":Y.AA.ARR.ID)
                        Y.REAL.INAU.RECORD<-1> = Y.AA.ID:" - ":"Record is not in both live and INAU"
                    END

                END
                Y.VAR3 += 1
            REPEAT
        END
        Y.VAR2 += 1
    REPEAT

RETURN
*---------------------------------------------------------
CHECK.AAA.INAU:
*---------------------------------------------------------
* Here we will check whether any INAU activities are there for that arrangement.

    Y.AAA.STATUS = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACT.HIST,F.AA.ACTIVITY.HISTORY,ACT.ERR)
    FINDSTR 'UNAUTH' IN R.AA.ACT.HIST<AA.AH.ACT.STATUS> SETTING POS1,POS2,POS3 THEN
        Y.AAA.STATUS = 'UNAUTH'
    END ELSE
        Y.AAA.STATUS = 'AUTH'
    END

RETURN
*---------------------------------------------------------
OPEN.REQ.FILES:
*---------------------------------------------------------
* Open required files.

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARRANGEMENT.DATED.XREF = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF  = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)

    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY  = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    Y.ERROR.IDS   = ''
    Y.REVIEW.IDS  = ''
    Y.NO.INAU.IDS = ''
    Y.CORRECTED.IDS = ''
    Y.REAL.INAU.RECORD = ''
RETURN
END

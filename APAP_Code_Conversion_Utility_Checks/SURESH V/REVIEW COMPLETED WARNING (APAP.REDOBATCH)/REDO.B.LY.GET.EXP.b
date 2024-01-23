* @ValidationCode : MjotMTY2MDY1MTgzMzpDcDEyNTI6MTcwNDM2NDM3NDY0OTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:02:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LY.GET.EXP(ID.LIST)
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine is attached to the batch record BNK/REDO.B.LY.GET.EXP
*  This routine get all the points to be expired daily and make the proper
*  changes in records of available and due points
* ------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 21-jun-2010       A.Velasco     ODR-2011-06-0243       Initial Creation
*                   RMONDRAGON
* 29-nov-2013       RMONDRAGON    ODR-2011-06-0243        Update
* 04-APR-2023     Conversion tool    R22 Auto conversion    ++ to +=, CONVERT to CHANGE, TNO to C$T24.SESSION
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18/01/2024         Suresh          R22 Auto Conversion   Change F.READ to F.READU
*-------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_REDO.B.LY.GET.EXP.COMMON


    GOSUB INITIALISE
    GOSUB OPEN.FILES
    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======

    LOOP
        REMOVE Y.ID.TO.PROC FROM ID.LIST SETTING ID.POS
    WHILE Y.ID.TO.PROC:ID.POS
        Y.ID = FIELD(Y.ID.TO.PROC,',',1)
        CNT  = FIELD(Y.ID.TO.PROC,',',2)
        CNT2 = FIELD(Y.ID.TO.PROC,',',3)
*CALL F.READ(FN.REDO.LY.POINTS,Y.ID,R.REDO.LY.POINTS,F.REDO.LY.POINTS,Y.ERR)
        CALL F.READU(FN.REDO.LY.POINTS,Y.ID,R.REDO.LY.POINTS,F.REDO.LY.POINTS,Y.ERR,'');* R22 AUTO CONVERSION
        IF R.REDO.LY.POINTS THEN
            GOSUB REG.EXP.REC
            GOSUB ASSIGN.AUDIT
            CALL F.WRITE(FN.REDO.LY.POINTS,Y.ID,R.REDO.LY.POINTS)
        END
    REPEAT

RETURN
*
* ==========
REG.EXP.REC:
* ==========
* This section gets the points record to be expired and update it with the status "Expirada" (Expired)

    Y.REDO.PT.PROGRAM  = R.REDO.LY.POINTS<REDO.PT.PROGRAM,CNT,CNT2>
    Y.REDO.PT.QUANTITY = R.REDO.LY.POINTS<REDO.PT.QUANTITY,CNT,CNT2>
    Y.QTY.VALUE        = R.REDO.LY.POINTS<REDO.PT.QTY.VALUE,CNT,CNT2>
    Y.GEN.DATE         = R.REDO.LY.POINTS<REDO.PT.GEN.DATE,CNT,CNT2>

    Y.TO.DAY     = Y.GEN.DATE
    Y.CURR.MONTH = SUBSTRINGS(Y.TO.DAY,5,2)
    Y.CURR.YEAR  = SUBSTRINGS(Y.TO.DAY,1,4)
    Y.CURR.DAY   = SUBSTRINGS(Y.TO.DAY,7,2)

    GOSUB GET.POINTFOR

    GOSUB UP.ALL.TOT

    R.REDO.LY.POINTS<REDO.PT.STATUS,CNT,CNT2> = "Expirada"

RETURN
*
* ===========
GET.POINTFOR:
* ===========

    R.REC.PROG = ""; PROG.ERR = ""
    CALL F.READ(FN.REDO.LY.PROGRAM,Y.REDO.PT.PROGRAM,R.REC.PROG,F.REDO.LY.PROGRAM,PROG.ERR)
    IF R.REC.PROG THEN
        Y.POINTFOR = R.REC.PROG<REDO.PROG.POINT.USE>
    END

RETURN
*
* =========
UP.ALL.TOT:
* =========
* Get info from REDO.LY.POINTS.TOT
    Y.ACCMOV = "N"

    Y.ID.POINTS.TOT = Y.ID:Y.REDO.PT.PROGRAM:Y.CURR.MONTH:Y.CURR.YEAR
* Process for Update
    GOSUB PROC.UPDATE

* Update for complementary records
    Y.ID.POINTS.TOT = Y.ID:Y.REDO.PT.PROGRAM:'ALL':Y.CURR.YEAR
    GOSUB PROC.UPDATE

    Y.ID.POINTS.TOT = Y.ID:"ALL":Y.CURR.YEAR
    GOSUB PROC.UPDATE

    Y.ID.POINTS.TOT = "ALL":Y.REDO.PT.PROGRAM
    GOSUB PROC.UPDATE

    Y.ID.POINTS.TOT = "ALL":Y.REDO.PT.PROGRAM:Y.CURR.MONTH:Y.CURR.YEAR
    GOSUB PROC.UPDATE

    Y.ID.POINTS.TOT = "ALL":Y.REDO.PT.PROGRAM:Y.CURR.YEAR
    GOSUB PROC.UPDATE

    Y.ID.POINTS.TOT = "ALL":Y.CURR.YEAR
    GOSUB PROC.UPDATE

    IF Y.POINTFOR EQ '3' THEN
        Y.ID.POINTS.TOT = Y.ID:"B"
        GOSUB PROC.UPDATE
    END

    IF Y.POINTFOR EQ '4' THEN
        Y.ID.POINTS.TOT = Y.ID:"C"
        GOSUB PROC.UPDATE
    END

    Y.ID.POINTS.TOT = "ALL":Y.REDO.PT.PROGRAM:Y.CURR.DAY:Y.CURR.MONTH:Y.CURR.YEAR
    Y.ACCMOV = "Y"
    GOSUB PROC.UPDATE

RETURN
*
* ==========
PROC.UPDATE:
* ==========

    CALL F.READU(FN.REDO.LY.POINTS.TOT,Y.ID.POINTS.TOT,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,Y.ERR,'')

    IF R.REDO.LY.POINTS.TOT THEN

        Y.TOT.AVAIL.POINTS = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
        Y.TOT.DUE.POINTS   = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.DUE.POINTS>
        Y.TOT.AVAIL.VALUE  = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>
        Y.TOT.DUE.VALUE    = R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.DUE.VALUE>

        GOSUB UPD.TOT.AVAIL.POINTS
        GOSUB UPD.TOT.DUE.POINTS
        GOSUB WRITE.REDO.LY.POINTS.TOT

    END


RETURN

* ===================
UPD.TOT.AVAIL.POINTS:
* ===================
*
*Update process, calculate Avail: Points & Value
*
    Y.NEW.TOT.AVAIL.POINTS = Y.TOT.AVAIL.POINTS - Y.REDO.PT.QUANTITY
    Y.NEW.TOT.AVAIL.VALUE  = Y.TOT.AVAIL.VALUE  - Y.QTY.VALUE


RETURN
*
* ==================
UPD.TOT.DUE.POINTS:
* ==================
*
*Update process, calculate Due: Points & Value
*
    Y.NEW.TOT.DUE.POINTS  = Y.TOT.DUE.POINTS  + Y.REDO.PT.QUANTITY
    Y.NEW.TOT.DUE.VALUE   = Y.TOT.DUE.VALUE   + Y.QTY.VALUE

RETURN
*
* =======================
WRITE.REDO.LY.POINTS.TOT:
* =======================
*
*Write the record with new values & points for Avail & Due
*
    IF Y.ACCMOV EQ "N" THEN
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>  = Y.NEW.TOT.AVAIL.POINTS
        R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.VALUE>   = Y.NEW.TOT.AVAIL.VALUE
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.DUE.POINTS>    = Y.NEW.TOT.DUE.POINTS
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.DUE.VALUE>     = Y.NEW.TOT.DUE.VALUE

    GOSUB  ASSIGN.AUDIT.TOT

    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,Y.ID.POINTS.TOT,R.REDO.LY.POINTS.TOT)

RETURN
*
* ============
ASSIGN.AUDIT:
* ============
*
* This section updates audit fields of REDO.LY.POINTS table

    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")
    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS<REDO.PT.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1
    END
    R.REDO.LY.POINTS<REDO.PT.RECORD.STATUS> = ''
    R.REDO.LY.POINTS<REDO.PT.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS<REDO.PT.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS<REDO.PT.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS<REDO.PT.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS<REDO.PT.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS<REDO.PT.DEPT.CODE> = 1

RETURN
*
* ===============
ASSIGN.AUDIT.TOT:
* ===============
* This section updates audit fields of REDO.LY.POINTS.TOT table
*
    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")
    CHANGE ':' TO '' IN CUR.TIME
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1

RETURN

*
* =========
INITIALISE:
* =========
    PROCESS.GOAHEAD           = 1
RETURN
*
* =========
OPEN.FILES:
* =========
*
*
RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
RETURN
*
END

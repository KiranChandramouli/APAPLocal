$PACKAGE APAP.TAM
SUBROUTINE REDO.B.LY.FILE.GEN(Y.PRGM.ID)
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This subroutine is performed during daily COB. The functionality is performed only
* when "Envmo y Generacisn de Archivo" (file generation and shipment) option has been defined as
* point usage in the program and take all records by customer from REDO.LY.POINTS table to generates
* a plain text file with all this information. The frequency to generate this plain text file is taken
* from value of GEN.FREC field in REDO.LY.PROGRAM table with two options available: daily or monthly
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date             who           Reference            Description
* 03-MAY-2010   S.Marimuthu    ODR-2009-12-0276      Initial Creation
* 28-Sep-2010   S.Sudharsanan  0DR-2010-09-0012     Modification has done as per the CR-021
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_F.REDO.LY.POINTS
    $INSERT I_F.REDO.LY.LOG
    $INSERT I_F.REDO.LY.POINTS.TOT
    $INSERT I_F.DATES
    $INSERT I_REDO.B.LY.FILE.GEN.COMMON
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB PROCESS
    GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    FLAG.COUNT +=1
    SEL.CMD.PO = 'SELECT ':FN.REDO.LY.POINTS:' WITH PROGRAM EQ ':Y.PRGM.ID
    CALL EB.READLIST(SEL.CMD.PO,SEL.CMD.LIST.PO,'',NOF.PO,POINTS.ERR)
    LOOP
        REMOVE Y.PNTS.ID FROM SEL.CMD.LIST.PO SETTING POS.PT
    WHILE Y.PNTS.ID:POS.PT
        R.REC.POINTS = '' ;  VAR.TOT.QTY = ''
        CALL F.READ(FN.REDO.LY.POINTS,Y.PNTS.ID,R.REC.POINTS,F.REDO.LY.POINTS,POINTS.ERR)
        Y.PRODUCT = R.REC.POINTS<REDO.PT.PRODUCT>
        Y.PRODUCT = CHANGE(Y.PRODUCT,@VM,@FM)
        Y.CNT.PROD = DCOUNT(Y.PRODUCT,@FM)
        FLG.CNT = 1
        LOOP
        WHILE FLG.CNT LE Y.CNT.PROD
            Y.PRGM = R.REC.POINTS<REDO.PT.PROGRAM,FLG.CNT>
            Y.PRGM = CHANGE(Y.PRGM,@SM,@FM)
            COUNTER = 1
            FOUND.FLAG = 1
            LOOP
            WHILE FOUND.FLAG
                FIND Y.PRGM.ID IN Y.PRGM,COUNTER SETTING POS THEN
                    Y.PRD = R.REC.POINTS<REDO.PT.PRODUCT,FLG.CNT>
                    Y.TXN.ID = R.REC.POINTS<REDO.PT.TXN.ID,FLG.CNT,POS>
                    Y.QTY = R.REC.POINTS<REDO.PT.QUANTITY,FLG.CNT,POS>
                    Y.STATUS = R.REC.POINTS<REDO.PT.QUANTITY,FLG.CNT,POS>
                    Y.GEN.DATE = R.REC.POINTS<REDO.PT.GEN.DATE,FLG.CNT,POS>
                    Y.AVAIL.DATE = R.REC.POINTS<REDO.PT.AVAIL.DATE,FLG.CNT,POS>
                    Y.EXP.DATE = R.REC.POINTS<REDO.PT.EXP.DATE,FLG.CNT,POS>
                    GOSUB CHK.STATUS.GENDATE
                END ELSE
                    FOUND.FLAG = 0
                END
                COUNTER += 1 ;* R22 Auto conversion
            REPEAT
            FLG.CNT +=1
        REPEAT
        GOSUB UPD.REDO.LY.POINTS.TOT
    REPEAT
    IF VAR.TOT.REC EQ FLAG.COUNT THEN
        LOCK.FLUSH =''
        R.LOCKING= ''
        PTIME=TIME()
        Y.LOG.ID = TODAY:'FG'
        FTIME=OCONV(PTIME,"MTH")
        R.LOCKING<REDO.LOG.PROC.DATE> = TODAY
        R.LOCKING<REDO.LOG.PROC.TIME> = FTIME
        R.LOCKING<REDO.LOG.FILE> = FILE.NAME
        R.LOCKING<REDO.LOG.STATUS> = 'Procesado: Archivo generado con ':RECNUM:' registros'
        CALL LOG.WRITE(FN.REDO.LY.LOG,Y.LOG.ID,R.LOCKING,LOCK.FLUSH)
    END
RETURN
*-------------------------------------------------------------------------------
CHK.STATUS.GENDATE:
*-------------------------------------------------------------------------------
* Checking status value and generation date value for generating file
    IF Y.STATUS EQ 'Liberada' THEN
        IF LASTMONTHWDAY EQ 'N' AND Y.GEN.DATE EQ TODAY THEN
            GOSUB UPD.FILE.GEN
        END ELSE
            IF Y.GEN.DATE GE FIRST.MONTH.DAY AND Y.GEN.DATE LE TODAY AND LASTMONTHWDAY EQ 'Y' THEN
                GOSUB UPD.FILE.GEN
            END
        END
    END
RETURN
*------------------------------------------------------------------------------
UPD.FILE.GEN:
*--------------------------------------------------------------------------------
* Update file generation for each customer with points details
    Y.TOT.VALUE = Y.PNTS.ID:'*':Y.PRD:'*':Y.PRGM.ID:'*':Y.TXN.ID:'*':Y.QTY:'*':Y.GEN.DATE:'*':Y.AVAIL.DATE:'*':Y.EXP.DATE
    RECNUM +=1
    VAR.TOT.QTY +=Y.QTY
    WRITESEQ Y.TOT.VALUE APPEND TO F.PATH ELSE
    END
RETURN
*------------------------------------------------------------------------------
UPD.REDO.LY.POINTS.TOT:
*---------------------------------------------------------------------------------
*Update the REDO.LY.POINTS.TOT local application based on the points generated in file
    GOSUB UPD.PTS.MMYY
    GOSUB UPD.PTS.PGM.YY
    GOSUB UPD.PTS.YYYY
    GOSUB UPD.PTS.ALL.PGM
    GOSUB UPD.PTS.ALL.PGM.MMYY
    GOSUB UPD.PTS.ALL.PGM.YY
    GOSUB UPD.PTS.ALL.YYYY
RETURN
*------------------------------------------------------------------------------
UPD.PTS.MMYY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = Y.PNTS.ID:Y.PRGM.ID:CUR.MONTH:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.PGM.YY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = Y.PNTS.ID:Y.PRGM.ID:'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.YYYY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = Y.PNTS.ID:'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = 'ALL':Y.PRGM.ID
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM.YY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = 'ALL':Y.PRGM.ID:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.PGM.MMYY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = 'ALL':Y.PRGM.ID:CUR.MONTH:CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PTS.ALL.YYYY:
*---------------------------------------------------------------------------------
    TOT.POINTS.ID = 'ALL':CUR.YEAR
    R.REDO.LY.POINTS.TOT =''
    CALL F.READU(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT,F.REDO.LY.POINTS.TOT,TOT.ERR,'')
    GOSUB UPD.PROCESS
    GOSUB ASSIGN.AUDIT
    CALL F.WRITE(FN.REDO.LY.POINTS.TOT,TOT.POINTS.ID,R.REDO.LY.POINTS.TOT)
RETURN
*------------------------------------------------------------------------------
UPD.PROCESS:
*---------------------------------------------------------------------------------
    VAR.AVAIL = '' ; VAR.USED = ''
    VAR.AVAIL   =  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS>
    VAR.USED   =  R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS>
    VAR.AVAIL -= VAR.TOT.QTY
    VAR.USED += VAR.TOT.QTY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.AVAIL.POINTS> = VAR.AVAIL
    R.REDO.LY.POINTS.TOT<REDO.PT.T.TOT.USED.POINTS> = VAR.USED
RETURN
*--------------------------------------------------------------------------------
ASSIGN.AUDIT:
*-------------------------------------------------------------------------------
* This section updates audit fields of REDO.LY.POINTS table
*----------------------------------------------------------
    CURR.NO = ''
    CUR.TIME = OCONV(TIME(), "MT")
    CHANGE ':' TO '' IN CUR.TIME ;* R22 Auto conversion
    CURR.NO = R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO>
    IF CURR.NO EQ '' THEN
        CURR.NO = 1
    END ELSE
        CURR.NO += 1 ;* R22 Auto conversion
    END
    R.REDO.LY.POINTS.TOT<REDO.PT.T.RECORD.STATUS> = ''
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CURR.NO> = CURR.NO
    R.REDO.LY.POINTS.TOT<REDO.PT.T.INPUTTER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DATE.TIME> = G.DATE[3,6]:CUR.TIME
    R.REDO.LY.POINTS.TOT<REDO.PT.T.AUTHORISER> = C$T24.SESSION.NO:'_':OPERATOR ;* R22 Auto conversion
    R.REDO.LY.POINTS.TOT<REDO.PT.T.CO.CODE> = ID.COMPANY
    R.REDO.LY.POINTS.TOT<REDO.PT.T.DEPT.CODE> = 1
RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END

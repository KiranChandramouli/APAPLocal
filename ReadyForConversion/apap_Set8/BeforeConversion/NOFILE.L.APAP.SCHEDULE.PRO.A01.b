*-----------------------------------------------------------------------------
* <Rating>226</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE NOFILE.L.APAP.SCHEDULE.PRO.A01(Y.DATA)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : NOFILE.L.APAP.SCHEDULE.PRO.A01
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO               DESCRIPTION
*  20200531         ELMENDEZ          INITIAL CREATION
*-----------------------------------------------------------------------------
    $INCLUDE T24.BP I_COMMON
    $INCLUDE T24.BP I_EQUATE
    $INCLUDE BP I_F.EB.L.APAP.SCHEDULE.PROJET
    $INCLUDE T24.BP I_ENQUIRY.COMMON    
*-----------------------------------------------------------------------------
INIT:
    GOSUB INITILISATION
    *GOSUB OPENFILES
    GOSUB SELECTCMD
    *GOSUB READFILES
    GOSUB PROCESSDATA
    RETURN

INITILISATION:
    FN.SCHEDULE.PROJ = 'F.EB.L.APAP.SCHEDULE.PROJET'
    FN.SCHEDULE.PROJ<2> = 'NO.FATAL.ERROR'
    F.SCHEDULE.PROJ  = ''

    ID.SCHEDULE.PROJ = ''
    R.SCHEDULE.PROJ = ''
    SCHEDULE.PROJ.ERR = ''

    Y.ARRANGEMENT.ID = ''
    Y.PROJECTION.DATE = ''
    Y.PJ.YYYYMMDD = ''

    SEL.CMD = ''


    *AA1511417411*20200415
    *AA1511417411*20200416
    RETURN

OPENFILES:
    CALL OPF(FN.SCHEDULE.PROJ , F.SCHEDULE.PROJ)
    RETURN

SELECTCMD:
    *DEBUG
    
    *D.FIELDS
    *D.LOGICAL.OPERANDS
    *D.RANGE.AND.VALUES

    LOCATE "ARRANGEMENT.ID" IN D.FIELDS SETTING POS THEN Y.ARRANGEMENT.ID = D.RANGE.AND.VALUE<POS>
    LOCATE "PROJECTION.DATE" IN D.FIELDS SETTING POS THEN  Y.PROJECTION.DATE = D.RANGE.AND.VALUE<POS> ELSE Y.PROJECTION.DATE  = '*'


    IF Y.PROJECTION.DATE = '*' THEN
        *LIST FBNK.EB.L.APAP.SCHEDULE.PROJET 'AA1511417411*...' BY-DSND @ID
        SEL.CMD = "SELECT FBNK.EB.L.APAP.SCHEDULE.PROJET '" :  Y.ARRANGEMENT.ID : "*...' BY-DSND @ID" 
    END 
    *ELSE 
        *LIST FBNK.EB.L.APAP.SCHEDULE.PROJET 'AA1511417411*...' AND EVAL'@ID[8]' GE '20200510' BY-DSND @ID
    *    SEL.CMD = "SELECT FBNK.EB.L.APAP.SCHEDULE.PROJET '" :  Y.ARRANGEMENT.ID : "*" : Y.PROJECTION.DATE : "' BY-DSND @ID" 
    *END

    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.REC,SEL.ERR)

    RETURN;

READFILES:
    CALL F.READ(FN.SCHEDULE.PROJ, ID.SCHEDULE.PROJ, R.SCHEDULE.PROJ, F.SCHEDULE.PROJ, SCHEDULE.PROJ.ERR)
    RETURN

PROCESSDATA:
    *DEBUG
    LOOP
        REMOVE AA.ARR.ID.YYYYMMDD FROM SEL.LIST SETTING PRESTAMOS
    WHILE AA.ARR.ID.YYYYMMDD:PRESTAMOS
        IF Y.PROJECTION.DATE = '*' THEN
            Y.DATA<-1> = AA.ARR.ID.YYYYMMDD
        END
        ELSE
            Y.PJ.YYYYMMDD  = AA.ARR.ID.YYYYMMDD[8]
            IF Y.PROJECTION.DATE >= Y.PJ.YYYYMMDD THEN
                Y.DATA<-1> = AA.ARR.ID.YYYYMMDD
            END ELSE
                CONTINUE
            END
        END
    REPEAT
    RETURN

    RETURN
END

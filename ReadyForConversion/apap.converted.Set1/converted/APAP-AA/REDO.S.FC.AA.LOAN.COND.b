SUBROUTINE REDO.S.FC.AA.LOAN.COND(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.OVERDUE>L.LOAN.STATUS.1  FIELD
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
* PACS00727967    -   22-JAN-2019      -  GOPALA KRISHNAN R         - ISSUE FIX
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END

RETURN          ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
*PACS00727967 - S
*    REC.ID = ''
*    OD.REC = ''
*    OD.ERR = ''
*PACS00727967 - E
    INT.COND1 = ''  ;*PACS00765914
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    Y.REV.RT.TYPE.POS = LOC.REF.POS<1,1>
    IF Y.REV.RT.TYPE.POS GT 0 THEN
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
        INT.COND1 = RAISE(INT.COND)     ;*PACS00765914
        AA.ARR = INT.COND1<AA.OD.LOCAL.REF,Y.REV.RT.TYPE.POS,1>       ;* This hold the Value in the local field    ;*PACS00765914
    END
*PACS00727967 - S
*    IF AA.ARR EQ '' THEN
*        SEL.CMD = 'SELECT ' :FN.AA.OD:' WITH @ID LIKE ':Y.ARRG.ID:'...'
*        CALL EB.READLIST(SEL.CMD,SEL.CMD.LIST,'',SEL.CMD.NO,SEL.CMD.ERR)
*        REC.ID = SEL.CMD.LIST<SEL.CMD.NO>
*        CALL F.READ(FN.AA.OD,REC.ID,OD.REC,F.AA.OD,OD.ERR)
*        AA.ARR = OD.REC<AA.OD.LOCAL.REF,Y.REV.RT.TYPE.POS,1>
*    END
*PACS00727967 - E
RETURN
*------------------------
INITIALISE:
*=========

    PROCESS.GOAHEAD = 1
    Y.ARRG.ID = AA.ID
    PROPERTY.CLASS = 'OVERDUE'
    LOC.REF.APPL="AA.ARR.OVERDUE"
    LOC.REF.FIELDS="L.LOAN.COND"
    LOC.REF.POS=" "
    AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========
*PACS00727967 - S
*    FN.AA.OD = 'F.AA.ARR.OVERDUE'
*    F.AA.OD = ''
*    CALL OPF(FN.AA.OD,F.AA.OD)
*PACS00727967 - E
RETURN
*------------
END

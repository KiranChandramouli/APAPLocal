SUBROUTINE REDO.V.TEL.GROUP
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.TELLER.PROCESS table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.TEL.GROUP
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                   REFERENCE       DESCRIPTION
*27-05-2011     Sudharsanan S           PACS00062653    Initial Creation
*31-01-2013     Vignesh Kumaar M R      PACS00245695    Invalid error messages during version validation
*-----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TELLER.PROCESS
    $INSERT I_F.REDO.TT.GROUP.PARAM
    $INSERT I_F.REDO.H.MAIN.COMPANY
    $INSERT I_GTS.COMMON

* Fix for RTC-569126 [Invalid error messages during version validation]

    IF OFS.VAL.ONLY EQ '1' AND MESSAGE EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

* End of Fix

RETURN
*---
INIT:
*---

    FN.REDO.H.MAIN.COMPANY ='F.REDO.H.MAIN.COMPANY'
    F.REDO.H.MAIN.COMPANY = ''
    CALL OPF(FN.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY)

    FN.REDO.TT.GROUP.PARAM = 'F.REDO.TT.GROUP.PARAM'
    F.REDO.TT.GROUP.PARAM = ''
    CALL OPF(FN.REDO.TT.GROUP.PARAM,F.REDO.TT.GROUP.PARAM)

    Y.SUB.GROUP = ''
    Y.FLAG = ''
    CALL CACHE.READ(FN.REDO.TT.GROUP.PARAM,'SYSTEM',R.REDO.TT.GROUP.PARAM,GRO.ERR)
    VAR.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.GROUP>

RETURN
*-------
PROCESS:
*-------
*To validate the fields and updates the value
    Y.GROUP = COMI
    LOCATE Y.GROUP IN VAR.GROUP<1,1> SETTING POS.VM THEN
        VAR.SUB.GROUP = R.REDO.TT.GROUP.PARAM<TEL.GRO.SUB.GROUP,POS.VM>
        CHANGE @SM TO "_" IN VAR.SUB.GROUP
        T(TEL.PRO.SUB.GROUP)="":@FM:VAR.SUB.GROUP
    END ELSE
        R.NEW(TEL.PRO.SUB.GROUP) = ''
        R.NEW(TEL.PRO.CONCEPT) = ''
        R.NEW(TEL.PRO.CURRENCY) = ''
        R.NEW(TEL.PRO.AMOUNT) = ''
        R.NEW(TEL.PRO.CATEGORY) = ''
        AF = TEL.PRO.GROUP
        ETEXT = 'EB-PARAM.GROUP.NOT.DEFINED'
        CALL STORE.END.ERROR
    END
*    GOSUB BRANCH.UPDATE
RETURN
*---------------------------------------------------------------------------------------
BRANCH.UPDATE:
*---------------------------------------------------------------------------------------
    Y.GROUP = ID.COMPANY
    SEL.CMD.1 = 'SELECT ':FN.REDO.H.MAIN.COMPANY
    CALL EB.READLIST(SEL.CMD.1,SEL.LIST.1,'',NO.OF.RECS,DEP.ERR)

    LOOP
        REMOVE SEL.LIST.ID FROM SEL.LIST.1 SETTING POS
    WHILE SEL.LIST.ID:POS
        IF Y.GROUP EQ SEL.LIST.ID THEN
            CALL F.READ(FN.REDO.H.MAIN.COMPANY,Y.GROUP,R.REDO.H.MAIN.COMPANY,F.REDO.H.MAIN.COMPANY,Y.ERR)
            Y.CODE = R.REDO.H.MAIN.COMPANY<REDO.COM.CODE>
            Y.DES = R.REDO.H.MAIN.COMPANY<REDO.COM.DESCRIPTION>
            CHANGE @VM TO '_' IN Y.CODE
            CHANGE @VM TO '_' IN Y.DES
            T(TEL.PRO.BRANCH.DES) = "":@FM:Y.DES
            Y.FLAG = '1'
        END
    REPEAT

    IF NOT(Y.FLAG) THEN
        T(TEL.PRO.BRANCH.DES)<3> = 'NOINPUT'
        R.NEW(TEL.PRO.BRANCH.DES) = ''
    END

RETURN
END

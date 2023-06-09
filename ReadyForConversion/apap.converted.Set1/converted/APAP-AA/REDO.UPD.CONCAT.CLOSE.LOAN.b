SUBROUTINE REDO.UPD.CONCAT.CLOSE.LOAN
*----------------------------------------------------------
* Description: This routine is triggered as part of LENDING-UPDATE-POST.RESTRICT activity
* Concat file to close the loan.
* Input  Arg: N/A
* Output Arg: N/A

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                   DESCRIPTION
* 02-JAN-2012     H GANESH              PACS00174524 - B.43          Initial Draft.
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.APAP.CLEAR.PARAM


    IF c_aalocActivityStatus EQ 'AUTH' OR c_aalocActivityStatus EQ 'AUTH-REV' THEN
        GOSUB PROCESS
    END
RETURN
*-----------------------------------------------------------
PROCESS:
*-----------------------------------------------------------

    IN.AA.ID = c_aalocArrId

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

    FN.REDO.CONCAT.AA.CLOSURE.DAYS = 'F.REDO.CONCAT.AA.CLOSURE.DAYS'
    F.REDO.CONCAT.AA.CLOSURE.DAYS = ''
    CALL OPF(FN.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS)

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,PARA.ERR)
    Y.NO.OF.DAYS = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.LOAN.CLOSE.DAYS>
    IF Y.NO.OF.DAYS AND c_aalocActivityEffDate AND c_aalocActivityStatus EQ 'AUTH' THEN
        Y.NO.OF.DAYS = '+':Y.NO.OF.DAYS:'W'
        YREGION = ''
        R.REDO.CONCAT.AA.CLOSURE.DAYS = ''
        Y.EFF.DATE = c_aalocActivityEffDate
        CALL CDT(YREGION,Y.EFF.DATE,Y.NO.OF.DAYS)

        CALL F.READ(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.EFF.DATE,R.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS,CNCT.ERR)
        LOCATE IN.AA.ID IN R.REDO.CONCAT.AA.CLOSURE.DAYS SETTING POS ELSE
            R.REDO.CONCAT.AA.CLOSURE.DAYS<-1> = c_aalocArrId
            CALL F.WRITE(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.EFF.DATE,R.REDO.CONCAT.AA.CLOSURE.DAYS)
        END
    END

    IF Y.NO.OF.DAYS AND c_aalocActivityEffDate AND c_aalocActivityStatus EQ 'AUTH-REV' THEN
        Y.NO.OF.DAYS = '+':Y.NO.OF.DAYS:'W'
        YREGION = ''
        R.REDO.CONCAT.AA.CLOSURE.DAYS = ''
        Y.EFF.DATE = c_aalocActivityEffDate
        CALL CDT(YREGION,Y.EFF.DATE,Y.NO.OF.DAYS)

        CALL F.READ(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.EFF.DATE,R.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS,CNCT.ERR)
        LOCATE IN.AA.ID IN R.REDO.CONCAT.AA.CLOSURE.DAYS SETTING POS THEN
            DEL R.REDO.CONCAT.AA.CLOSURE.DAYS<POS>
            CALL F.WRITE(FN.REDO.CONCAT.AA.CLOSURE.DAYS,Y.EFF.DATE,R.REDO.CONCAT.AA.CLOSURE.DAYS)
        END
    END
RETURN
END

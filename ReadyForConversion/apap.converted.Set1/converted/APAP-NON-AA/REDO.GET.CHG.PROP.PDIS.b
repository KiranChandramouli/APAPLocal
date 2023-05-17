SUBROUTINE REDO.GET.CHG.PROP.PDIS(R.DATA)
*-----------------------------------------------------------------------------

* This routine is used to display the properties

* Modification History:

* Marimuthu S          28-Nov-2012             PACS00236823

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PROPERTY


    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)


    LOCATE 'Y.ARR.ID' IN D.FIELDS SETTING POS THEN
        Y.AA.ID = D.RANGE.AND.VALUE<POS>
    END


    Y.PROP.CLS = 'CHARGE'
    Y.RET.PROP = '' ; RET.COND = ''; RET.ERR = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,Y.PROP.CLS,'','',Y.RET.PROP,RET.COND,RET.ERR)

    Y.CNT = DCOUNT(Y.RET.PROP,@FM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.PROP = Y.RET.PROP<FLG>
        CALL CACHE.READ(FN.AA.PROPERTY, Y.PROP, R.PROP, PROP.ER)
        R.DATA<-1> = Y.PROP:'*':R.PROP<AA.PROP.DESCRIPTION,1>
        Y.CNT -= 1
    REPEAT

RETURN

END

SUBROUTINE REDO.CONV.PARENT.COMMENT.DET
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is attached as a conversion routine to the enquiry
* display the field description of EB.LOOKUP instead of the ID.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 07-03-2012         RIYAS      ODR-2012-03-0162     Initial Creation
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.EB.SECURE.MESSAGE
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.AUT.INP.VERSION.NAME
    $INSERT I_ENQUIRY.COMMON

    FN.EB.SECURE.MESSAGE = 'F.EB.SECURE.MESSAGE'
    F.EB.SECURE.MESSAGE  = ''
    CALL OPF(FN.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE)

    APPL.ARRAY = "EB.SECURE.MESSAGE"
    FIELD.ARRAY = "L.ESM.MSG.REP"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.L.ESM.MSG.REP = FIELD.POS<1,1>

    CALL F.READ(FN.EB.SECURE.MESSAGE,O.DATA,R.EB.SECURE.MESSAGE,F.EB.SECURE.MESSAGE,EB.SECURE.MESSAGE.ERR)
    Y.PARENT.MSG.ID = R.EB.SECURE.MESSAGE<EB.SM.PARENT.MESSAGE.ID>
    O.DATA = R.EB.SECURE.MESSAGE<EB.SM.LOCAL.REF,Y.L.ESM.MSG.REP>
    IF Y.PARENT.MSG.ID THEN
        O.DATA = R.EB.SECURE.MESSAGE<EB.SM.MESSAGE>
        Y.CUS.REPLY =  R.EB.SECURE.MESSAGE<EB.SM.LOCAL.REF,Y.L.ESM.MSG.REP>
        IF O.DATA AND Y.CUS.REPLY THEN
            O.DATA = Y.CUS.REPLY
        END
    END


RETURN

SUBROUTINE REDO.SLA.PARAM.ID
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to check the ID value for the table
* REDO.SLA.PARAM
*------------------------------------------------------------------------------
*------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RENUGADEVI B
* PROGRAM NAME : REDO.SLA.PARAM.ID
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE           DESCRIPTION
* 06-AUG-2010      Renugadevi B       ODR-2009-12-0283    INITIAL CREATION
* 13-MAY-2011      Pradeep S          PACS00060849        Id INTERACCION changed to QUEJAS
* ----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.SLA.PARAM
    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
******
    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)
RETURN

********
PROCESS:
********
    Y.ID = ID.NEW
    Y.PARAM.ID = FIELD(Y.ID,'-',1,1)
* IF Y.PARAM.ID EQ 'RECLAMACION' OR Y.PARAM.ID EQ 'SOLICITUD' OR Y.PARAM.ID EQ 'INTERACCION' THEN
    IF Y.PARAM.ID MATCHES 'RECLAMACION':@VM:'SOLICITUD':@VM:'QUEJAS' ELSE
        E = "Enter Valid TYPE"
        RETURN
    END

    Y.PRDT.TYPE = FIELD(Y.ID,'-',2,1)
    IF Y.PRDT.TYPE THEN
        Y.PRDT.ID = "RE.PRODUCT.TYPE*":Y.PRDT.TYPE
        CALL F.READ(FN.EB.LOOKUP,Y.PRDT.ID,R.LOOKUP,F.EB.LOOKUP,ERR.LOOKUP)
        IF ERR.LOOKUP THEN
            E = "Enter Valid Product Type"
        END
    END

RETURN
END

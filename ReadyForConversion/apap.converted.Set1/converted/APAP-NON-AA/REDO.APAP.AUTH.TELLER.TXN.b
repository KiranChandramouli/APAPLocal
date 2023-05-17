SUBROUTINE REDO.APAP.AUTH.TELLER.TXN
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU S
*  Program   Name    :REDO.APAP.AUTH.TELLER.TXN
***********************************************************************************
*Description:    This is an AUTHORISATION routine attached to the Enquiry used
*                to authorise the teller transaction when the user clicks the authorise button
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*25-MAY-2011       DHAMU.S               PACS00061652       INITIAL CREATION
****************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.TELLER

    GOSUB OPEN
    GOSUB PROCESS
RETURN

*****
OPEN:
*****

    FN.TELLER = 'F.TELLER'
    F.TELLER  = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

RETURN

********
PROCESS:
********
    Y.RECORD.STATUS  = R.NEW(TT.TE.RECORD.STATUS)
    IF Y.RECORD.STATUS EQ 'INAU' THEN
        Y.USER = OPERATOR
        Y.TELLER.ID.1 = R.NEW(TT.TE.TELLER.ID.1)
        CALL F.READ(FN.TELLER.ID,Y.TELLER.ID.1,R.TELLER.ID,F.TELLER.ID,TT.ERR)
        TT.USR1  = R.TELLER.ID<TT.TID.USER>
        Y.TELLER.ID.2 = R.NEW(TT.TE.TELLER.ID.2)
        CALL F.READ(FN.TELLER.ID,Y.TELLER.ID.2,R.TELLER.ID,F.TELLER.ID,TT.ERR1)
        TT.USR2  = R.TELLER.ID<TT.TID.USER>
        IF TT.USR1 EQ Y.USER OR TT.USR2 EQ Y.USER ELSE
            AF    = TT.TE.TELLER.ID.1
            E     = 'EB-TELLER.NOT.AUTH'
        END
    END
RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------

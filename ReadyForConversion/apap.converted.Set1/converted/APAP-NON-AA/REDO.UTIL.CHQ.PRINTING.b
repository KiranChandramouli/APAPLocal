SUBROUTINE REDO.UTIL.CHQ.PRINTING(IN.DAT,OUT.DAT,MSG.DAT,XSL.NAME)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.PRINT.CHQ.LIST

    MSG.DAT = 'XML.ENQUIRY'
    XSL.NAME = '/transforms/custom/getValue.xsl'

    Y.REC.ID = FIELD(IN.DAT,'###',1)
    Y.DEAL.ID = FIELD(IN.DAT,'###',2)

    Y.TYPE = R.NEW(PRINT.CHQ.LIST.CHQ.TYPE)
    Y.PRINTER = R.NEW(PRINT.CHQ.LIST.SET.PRINTER)

    IF (Y.TYPE EQ 'ADMIN' AND Y.PRINTER EQ 'RICOH') OR (Y.TYPE EQ 'MANAGER' AND Y.PRINTER EQ 'OLIVETTI') THEN
        FINAL.OUT = '<passbookprintdata><title>Admin Cheque</title>'
    END ELSE
        FINAL.OUT = '<passbookprintdata><title>Manager Cheque</title>'
    END

    IF NUM(Y.DEAL.ID) ELSE

* Fix for PACS00396866 [Junk value produced in Cheque]

        IF ID.NEW EQ '' THEN
            ID.NEW = Y.DEAL.ID
        END

* End of Fix

        CALL PRODUCE.DEAL.SLIP(Y.DEAL.ID)
        Y.DEAL.ID = C$LAST.HOLD.ID
    END

    FN.HOLD = "&HOLD&"
    OPEN FN.HOLD TO F.HOLD ELSE
        RETURN
    END

    READ R.HOLD FROM F.HOLD, Y.DEAL.ID ELSE
        RETURN
    END

*    IF R.HOLD<1> EQ '' THEN
*        DEL R.HOLD<1>
*    END

    LM = CHARX(12)
    CHANGE LM TO '' IN R.HOLD

    LOOP
        REMOVE GET.DEAL.INFO FROM R.HOLD SETTING HOLD.POS
    WHILE GET.DEAL.INFO:HOLD.POS

        GOSUB FINAL.TAG
    REPEAT

    FINAL.OUT := '</passbookprintdata>'

    OUT.DAT = FINAL.OUT
*    CRT OUT.DAT
RETURN

FINAL.TAG:

*    FINAL.OUT:= '<r><c><cap>':V.COMPANY:'</cap></c><c><cap>':FLAG:'</cap></c></r>'
    FINAL.OUT := '<line>':GET.DEAL.INFO:'</line>'

RETURN

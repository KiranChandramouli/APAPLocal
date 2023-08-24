*-----------------------------------------------------------------------------
* <Rating>99</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE APAP.M.UPD.PROD.CODE
* 02/01/2017 - Sunder - ITSS
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.COMPANY.CONSOL
    $INSERT I_F.SPF

    FN.COMPANY.CONSOL = "F.COMPANY.CONSOL"
    F.COMPANY.CONSOL = ""
    CALL OPF(FN.COMPANY.CONSOL,F.COMPANY.CONSOL)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.SL = '&SAVEDLISTS&'
    F.SL = ''
    CALL OPF(FN.SL,F.SL)

    R.COMPANY.CONSOL = ""
    Y.COMPANY.CONSOL.ERR = ""
    Y.SL.STRING = ""

    Y.SPF.PROD = R.SPF.SYSTEM<SPF.PRODUCTS>

    CALL F.READ(FN.COMPANY.CONSOL,"001",R.COMPANY.CONSOL,F.COMPANY.CONSOL,Y.COMPANY.CONSOL.ERR)

    IF Y.COMPANY.CONSOL.ERR THEN RETURN

    Y.PROD.CODES = "RS":VM:"PO":VM:"SF":VM:"IN"
    Y.PROD.CNT = DCOUNT(Y.PROD.CODES,VM)
    FOR I = 1 TO Y.PROD.CNT
        LOCATE Y.PROD.CODES<1,I> IN Y.SPF.PROD<1,1> SETTING PROD.POS ELSE
            E = "All the new product conditions(RS, PO, SF and IN) is not updated in the SPF"
            CALL ERR
            RETURN
        END
    NEXT I

    Y.COMPANY.IDS = R.COMPANY.CONSOL<EB.CCO.COM.CONSOL.FROM>

    CONVERT VM TO FM IN Y.COMPANY.IDS

    LOOP
        REMOVE Y.COMPANY.ID FROM Y.COMPANY.IDS SETTING COMP.POS
    WHILE Y.COMPANY.ID:COMP.POS
        Y.WRITE.FLAG = ''
        R.COMP = ''
        Y.COMP.ERR = ''
        CALL F.READ(FN.COMPANY,Y.COMPANY.ID,R.COMP,F.COMPANY,Y.COMP.ERR)
        IF Y.COMP.ERR THEN
            CONTINUE
        END
        ELSE
            LOCATE 'RS' IN R.COMP<EB.COM.APPLICATIONS,1> SETTING Y.PRD.POS ELSE
                R.COMP<EB.COM.APPLICATIONS,-1> = 'RS'
                Y.WRITE.FLAG = 'Y'
            END
            LOCATE 'PO' IN R.COMP<EB.COM.APPLICATIONS,1> SETTING Y.PRD.POS ELSE
                R.COMP<EB.COM.APPLICATIONS,-1> = 'PO'
                Y.WRITE.FLAG = 'Y'
            END
            LOCATE 'SF' IN R.COMP<EB.COM.APPLICATIONS,1> SETTING Y.PRD.POS ELSE
                R.COMP<EB.COM.APPLICATIONS,-1> = 'SF'
                Y.WRITE.FLAG = 'Y'
            END
            LOCATE 'IN' IN R.COMP<EB.COM.APPLICATIONS,1> SETTING Y.PRD.POS ELSE
                R.COMP<EB.COM.APPLICATIONS,-1> = 'IN'
                Y.WRITE.FLAG = 'Y'
            END
        END
        IF Y.WRITE.FLAG EQ 'Y' THEN
            CALL F.LIVE.WRITE(FN.COMPANY,Y.COMPANY.ID,R.COMP)
            Y.SL.STRING<-1> = "Updating the product codes for the company : " : Y.COMPANY.ID
            CALL F.WRITE(FN.SL,'PROD.UPD.STATUS',Y.SL.STRING)
            CALL JOURNAL.UPDATE("")
        END
    REPEAT

    RETURN
END

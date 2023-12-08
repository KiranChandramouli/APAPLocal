* @ValidationCode : Mjo0ODQ3MDQwNTk6Q3AxMjUyOjE3MDIwMzIzNDIzMzE6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 08 Dec 2023 16:15:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
*-----------------------------------------------------------------------------
* <Rating>99</Rating>
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*21-08-2023    VICTORIA S          R22 MANUAL CONVERSION   FM TO @FM,VM TO @VM
*08-12-2023     SURESH             R22 MANUAL CODE CONVERISON  OPF TO OPEN
*----------------------------------------------------------------------------------------
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
*CALL OPF(FN.SL,F.SL)
    OPEN FN.SL TO F.SL ELSE
    END ;*R22 MANUAL CODE CONVERISON

    R.COMPANY.CONSOL = ""
    Y.COMPANY.CONSOL.ERR = ""
    Y.SL.STRING = ""

    Y.SPF.PROD = R.SPF.SYSTEM<SPF.PRODUCTS>

    CALL F.READ(FN.COMPANY.CONSOL,"001",R.COMPANY.CONSOL,F.COMPANY.CONSOL,Y.COMPANY.CONSOL.ERR)

    IF Y.COMPANY.CONSOL.ERR THEN RETURN

    Y.PROD.CODES = "RS":@VM:"PO":@VM:"SF":@VM:"IN" ;*R22 MANUAL CONVERSION
    Y.PROD.CNT = DCOUNT(Y.PROD.CODES,@VM) ;*R22 MANUAL CONVERSION
    FOR I = 1 TO Y.PROD.CNT
        LOCATE Y.PROD.CODES<1,I> IN Y.SPF.PROD<1,1> SETTING PROD.POS ELSE
            E = "All the new product conditions(RS, PO, SF and IN) is not updated in the SPF"
            CALL ERR
            RETURN
        END
    NEXT I

    Y.COMPANY.IDS = R.COMPANY.CONSOL<EB.CCO.COM.CONSOL.FROM>

    CONVERT @VM TO @FM IN Y.COMPANY.IDS ;*R22 MANUAL CONVERSION

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

* @ValidationCode : MjoyMjE4NDc5NDI6Q3AxMjUyOjE2ODE5MDU2Nzk5Mjk6SVRTUzotMTotMToyNzY6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:31:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 276
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.GET.PENAL.AMT(VAR.PENAL.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.PRINCIPAL
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the AMOUNT VALUE
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 FM TO @FM, VM TO @VM
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES

* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.STMT.ACCT.CR
    $INSERT I_F.DATES

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
***********
OPENFILES:
***********

    LOC.REF.APP = 'ACCOUNT.CLOSURE':@FM:'AZ.ACCOUNT'
    LOC.REF.FIELD = 'L.AC.AZ.ACC.REF':@FM:'ORIG.DEP.AMT':@VM:'L.AZ.PENAL.AMT'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)

    L.AC.AZ.ACC.REF.POS = LOC.REF.POS<1,1>
    L.ORIG.DEP.AMT.POS  = LOC.REF.POS<2,1>
    LOC.AZ.PEN.AMT = LOC.REF.POS<2,2>
    FN.STMT.ACCT.CR = 'FBNK.STMT.ACCT.CR'
    F.STMT.ACCT.CR=''
    CALL OPF(FN.STMT.ACCT.CR,F.STMT.ACCT.CR)
    Y.LAST.WORK = R.DATES(EB.DAT.LAST.WORKING.DAY)


RETURN
*********
PROCESS:
**********
    BEGIN CASE

        CASE APPLICATION EQ 'ACCOUNT.CLOSURE'

            FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT$HIS'
            F.AZ.ACCOUNT = ''
            CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

            VAR.ID = R.NEW(AC.ACL.LOCAL.REF)<1,L.AC.AZ.ACC.REF.POS>

            CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT,VAR.ID,R.AZ.ACCOUNT,AZ.ERR)

            Y.OVERRIDE = R.AZ.ACCOUNT<AZ.OVERRIDE>
            Y.CURR = R.AZ.ACCOUNT<AZ.CURRENCY>

            CHANGE @VM TO @FM IN Y.OVERRIDE

            FINDSTR "REDO.AZ.TOTAL.DUE" IN Y.OVERRIDE SETTING POS.VAL THEN
                VAR.OVERRIDE =  Y.OVERRIDE<POS.VAL>
                Y.PENAL.AMT =  FIELD(VAR.OVERRIDE,"{",2)
                PENAL.AMT  = TRIM(FMT(Y.PENAL.AMT,"L2,#19")," ",'B')
                VAR.PENAL.AMT = Y.CURR:" ":PENAL.AMT
            END

        CASE APPLICATION EQ 'AZ.ACCOUNT'

            Y.OVERRIDE = R.NEW(AZ.OVERRIDE)
            Y.CURR = R.NEW(AZ.CURRENCY)



            Y.PEN.AMT   = R.NEW(AZ.LOCAL.REF)<1,LOC.AZ.PEN.AMT>
            REC.ID = ID.NEW
            Y.ID = ID.NEW:"-":Y.LAST.WORK
            CALL F.READ(FN.STMT.ACCT.CR,Y.ID,R.STMT.ACCT.CR,F.STMT.ACCT.CR,ERR.STMT)

            IF R.STMT.ACCT.CR THEN

                AMOUNT = SUM(R.STMT.ACCT.CR<IC.STMCR.CR.VAL.BALANCE>)
                GRAND.TOTAL = R.STMT.ACCT.CR<IC.STMCR.GRAND.TOTAL>
                Y.PEN.AMOUNT = AMOUNT + GRAND.TOTAL - Y.PEN.AMT
                Y.PEN.AMOUNT = TRIM(FMT(Y.PEN.AMOUNT,"L2,#19")," ",'B')
                VAR.PENAL.AMT = Y.CURR:" ":Y.PEN.AMOUNT

            END
* ELSE

*    CHANGE VM TO FM IN Y.OVERRIDE

*    FINDSTR "REDO.AZ.TOTAL.DUE" IN Y.OVERRIDE SETTING POS.VAL THEN
*        VAR.OVERRIDE =  Y.OVERRIDE<POS.VAL>
*        Y.PENAL.AMT =  FIELD(VAR.OVERRIDE,"{",2)
*        PENAL.AMT  = TRIM(FMT(Y.PENAL.AMT,"L2,#19")," ",'B')
*        VAR.PENAL.AMT = Y.CURR:" ":PENAL.AMT
*    END
* END
    END CASE
RETURN
END
*----------------------------------------------- End Of Record ----------------------------------

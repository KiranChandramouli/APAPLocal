* @ValidationCode : Mjo1NTQxNDIzNzQ6Q3AxMjUyOjE2ODQ0OTEwMzE0MDY6SVRTUzotMTotMTo3NTM6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 753
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.COL.CANCEL.SALD
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.COL.CANCEL.SALD
* Attached as     : ROUTINE
* Primary Purpose : Set Collateral avaliable amount to 0
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Jorge Valarezo - TAM Latin America
* Date            : 10-Apr-2013
* Amd                     : MG - 04-09-2013
*
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT

    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB REMOVE.AC.STATUS


RETURN


*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------
    R.NEW(COLL.LOCAL.REF)<1,Y.AVA.BAL.POS> = 0
* PACS00260025 - S
*      IF R.NEW(COLL.COLLATERAL.CODE) NE '150' THEN
*         RETURN ;*This Function isvalid only for Collateral type 150
*      END
* PACS00260025 - E
    Y.APPLICATION.ID = R.NEW(COLL.LOCAL.REF)<1,LOC.L.NUM.INST>          ;*R.NEW(COLL.APPLICATION.ID)
* PACS00307565 - S
    SEL.AC.LOCKED.EVENTS.CMD="SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ ":Y.APPLICATION.ID
*  SEL.AC.LOCKED.EVENTS.CMD="SELECT ":FN.AC.LOCKED.EVENTS
    Y.CNT.LCKS = 0
* PACS00307565 - E
    CALL EB.READLIST(SEL.AC.LOCKED.EVENTS.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    LOOP
        REMOVE Y.AC.LOCK.ID FROM SEL.LIST SETTING AC.LOCK.POS
    WHILE Y.AC.LOCK.ID:AC.LOCK.POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)
* PACS00307565 - S
        Y.ALE.ACCT = R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
        Y.ALE.DESC = R.AC.LOCKED.EVENTS<AC.LCK.DESCRIPTION>
        Y.STATUS   = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.LOCL.TYPE>
*
        IF Y.STATUS EQ 'GUARANTEE.STATUS' AND Y.ALE.ACCT EQ Y.APPLICATION.ID AND Y.CO.ID EQ Y.ALE.DESC THEN
* PACS00307565 - E
* PACS00260025 - S
            Y.CNT.LCKS += 1 ;* R22 Auto conversion
* PACS00260025 - E
            OFS.SOURCE.ID = 'APAP.B.180.OFS'
            APPLICATION.NAME = 'AC.LOCKED.EVENTS'
            TRANS.FUNC.VAL = 'R'    ;*Instead Input function must be used reverser Function
            TRANS.OPER.VAL = 'PROCESS'
            APPLICATION.NAME.VERSION = 'AC.LOCKED.EVENTS,APAP'
            NO.AUT = '0'
            OFS.MSG.ID = ''
            APPLICATION.ID= Y.AC.LOCK.ID
            OFS.POST.MSG = ''
            OFS.AZ.MSG1=APPLICATION.NAME.VERSION:'/':TRANS.FUNC.VAL:'/':TRANS.OPER.VAL:'///,//,':Y.AC.LOCK.ID
            OFS.BODY=''   ;*',TO.DATE:1:1=':TODAY             in reverse function is not be avaliable to input new values
            OFS.REQ.MSG=OFS.AZ.MSG1:OFS.BODY
            CALL OFS.POST.MESSAGE (OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
        END
    REPEAT

RETURN
*----------------------------------------------------------------------------
REMOVE.AC.STATUS:
*=========

    Y.ACCOUNT.ID = Y.APPLICATION.ID
    Y.AZ.ACCOUNT.ID = Y.APPLICATION.ID

    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ERR)
    Y.VAR.AZ = R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.ACCOUNT>

* PACS00307565 - S
* Whether we are in last event linked to the current account
    IF Y.CNT.LCKS GT 0 THEN     ;* PACS00260025 - S/E

        LOCATE 'GUARANTEE.STATUS' IN R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.ACCOUNT,1> SETTING POS.AZ THEN
            R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.ACCOUNT, POS.AZ> = ''
            R.AZ.ACCOUNT<AZ.LOCAL.REF,Y.AZ.STATUS, POS.AZ>  = Y.AZ.STAT.AC
            CALL F.WRITE(FN.AZ.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.ACCOUNT)
*      CALL REDO.AZ.WRITE.TRACE('REDO.COL.CANCEL.SALD',Y.AZ.ACCOUNT.ID)
        END

        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

        LOCATE 'GUARANTEE.STATUS' IN R.ACCOUNT<AC.LOCAL.REF,Y.AC.ACCOUNT2,1> SETTING POS.AC THEN
            R.ACCOUNT<AC.LOCAL.REF,Y.AC.ACCOUNT>  = Y.ACC.STAT.AC
            R.ACCOUNT<AC.LOCAL.REF,Y.AC.ACCOUNT2, POS.AC> = ''
            CALL F.WRITE(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT)
        END

    END
* PACS00307565 - E

RETURN

*----------------------------------------------------------------------------

INITIALISE:
*=========

    Y.AVA.BAL.POS = ''
    LOC.REF.FIELDS = 'L.COL.VAL.AVA':@VM:'L.COL.NUM.INSTR':@FM:'L.AC.LOCKE.TYPE':@FM:'L.AC.STATUS2':@VM:'L.AC.STATUS':@FM:'L.AC.STATUS2':@VM:'L.AC.STATUS'    ;* PACS00307565 - S/E
    LOC.REF.APPL = 'COLLATERAL':@FM:'AC.LOCKED.EVENTS':@FM:'ACCOUNT':@FM:'AZ.ACCOUNT'
    LOC.REF.POS = ''

    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)

    Y.AVA.BAL.POS     = LOC.REF.POS<1,1>
    LOC.L.NUM.INST    = LOC.REF.POS<1,2>
    LOC.L.LOCL.TYPE   = LOC.REF.POS<2,1>
    Y.AC.ACCOUNT2     = LOC.REF.POS<3,1>
    Y.AC.ACCOUNT      = LOC.REF.POS<3,2>
    Y.AZ.ACCOUNT      = LOC.REF.POS<4,1>
* PACS00307565 - S
    Y.AZ.STATUS       = LOC.REF.POS<4,2>
    Y.AZ.STAT.AC      = "AC"
    Y.ACC.STAT.AC     = "AC"
    Y.ALE.ACCT        = ''
    Y.ALE.DESC        = ''
    Y.STATUS          = ''
    Y.CO.ID           = ID.NEW
* PACS00307565 - E

    FN.AC.LOCKED.EVENTS = "F.AC.LOCKED.EVENTS"
    F.AC.LOCKED.EVENTS = ""
    R.AC.LOCKED.EVENTS = ""
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    R.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT = ""
    R.AZ.ACCOUNT = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)


RETURN

END

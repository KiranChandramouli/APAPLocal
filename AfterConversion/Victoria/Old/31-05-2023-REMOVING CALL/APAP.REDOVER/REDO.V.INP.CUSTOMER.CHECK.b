* @ValidationCode : MjotMjEzNDA4NDk0NTpDcDEyNTI6MTY4MjQxMjM1MDQ1NzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CUSTOMER.CHECK
*---------------------------------------------------------------------------------
*This is an input routine for the version APAP.H.GARNISH.DETAILS,INP, it will check
*whether the registration of garnishment for APAP customer or not
*----------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : BHARATH C
* Program Name  : REDO.V.INP.GARNISHMENT.MAINT
* ODR NUMBER    : ODR-2009-10-0531
*LINKED WITH:APAP.H.GARNISH.DETAILS AS version routine
*----------------------------------------------------------------------
*Input param = none
*output param =none
*-----------------------------------------------------------------------
*MODIFICATION DETAILS:
*4.1.2010       ODR-2009-10-0531
*24-07-2011     PACS00071064      Prabhu N         Changes to add override.
*24-08-2011     PACS00103352      Prabhu N         EB.LOOKUP Changes
*13-03-2011     B88 PERFORMANCE   Prabhu N         Select removed for performance issue
*----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*11-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,F.READ TO CACHE.READ, = TO EQ
*11-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.APAP.H.GARNISH.DETAILS
    $INSERT I_GTS.COMMON
    $INSERT I_F.OVERRIDE

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
    Y.AMT.DEC = R.NEW(APAP.GAR.GARNISHMENT.AMT)
    R.NEW(APAP.GAR.GARNISHMENT.AMT) = FMT(Y.AMT.DEC,"R2#20")
RETURN
*-------------
INIT:
    NAME=''
    G.ID=''
    ID.TYPE=''
    ID.NO=''
    SEL.CMD=''
    SEL.FIELD=''
RETURN
*--------------
OPENFILE:

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CUS.ID=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.OVERRIDE='F.OVERRIDE'
    F.OVERRIDE=''
    CALL OPF(FN.OVERRIDE,F.OVERRIDE)

RETURN
*--------------
PROCESS:

*Check for Overrides
    IF NOT(OFS.VAL.ONLY) AND NOT(OFS$OVERRIDES) THEN
        GOSUB PROCESS1
    END
RETURN

PROCESS1:
********
* Getting the Override Message
    VAL.OVERRIDES=OFS$OVERRIDES
    VAR.OVERRIDE.ID='NOT.APAP.CUSTOMER'
    CALL CACHE.READ(FN.OVERRIDE, VAR.OVERRIDE.ID, R.OVERRIDE, ERR.MSG)   ;*R22 AUTO CODE CONVERSION

    VAR.MESSAGE1=R.OVERRIDE<EB.OR.MESSAGE>
    VAR.MESSAGE2='YES'

*Getting the Override Message Values

    VAR.OFS.OVERRIDE1=OFS$OVERRIDES<1>
    VAR.OFS.OVERRIDE2=OFS$OVERRIDES<2>
    CHANGE @VM TO @FM IN VAR.OFS.OVERRIDE2
    LOCATE VAR.MESSAGE2 IN VAR.OFS.OVERRIDE2 SETTING POS2 ELSE POS2 = ''
    IF POS2 EQ '' THEN
        GOSUB PROCESS2
    END
RETURN

*********
PROCESS2:

*Check the Customer
    NAME=R.NEW(APAP.GAR.INDIVIDUAL.NAME)
    ID.TYPE=R.NEW(APAP.GAR.IDENTITY.TYPE)
    SEL.VAL=R.NEW(APAP.GAR.IDENTITY.NUMBER)
    G.ID=ID.NEW
    R.NEW(APAP.GAR.OVERRIDE)=''
*PACS00103352-S
    IF ID.TYPE EQ 'ID.CARD' THEN
*PACS00103352-E
        SEL.FIELD='L.CU.CIDENT'
    END
    IF ID.TYPE EQ 'PASSPORT' THEN
        SEL.FIELD='LEGAL.ID'
    END
    IF ID.TYPE EQ 'RNC' THEN
        SEL.FIELD='L.CU.RNC'
    END
*    SEL.CMD="SELECT ":FN.CUSTOMER:" WITH ":SEL.FIELD:" EQ ":SEL.VAL:" AND (NAME.1 EQ '":NAME:"' OR NAME.2 EQ '":NAME:"')"
*    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECORD,ERR.SEL)
*    LOOP
*        REMOVE CUS.ID FROM SEL.LIST SETTING POS
*    WHILE CUS.ID:POS
*
*        R.NEW(APAP.GAR.CUSTOMER)=CUS.ID
*
*    REPEAT
    Y.APAP.CUSTOMER.ID = R.NEW(APAP.GAR.CUSTOMER)

    IF NOT(Y.APAP.CUSTOMER.ID) THEN
        TEXT='NOT.APAP.CUSTOMER'
        AF=APAP.GAR.ID.NUMBER
        CURR.NO=DCOUNT(R.NEW(APAP.GAR.OVERRIDE),@VM) + 1
        CALL STORE.OVERRIDE(CURR.NO)
        IF TEXT EQ 'NO' THEN
            GOSUB EXIT.SUB
        END

    END
    ELSE
*PACS00071064-----------------------------------------
        Y.LOCKED.AMOUNT=R.NEW(APAP.GAR.AMOUNT.LOCKED)
        VAR.GARNISH.AMT=R.NEW(APAP.GAR.GARNISHMENT.AMT)
        IF Y.LOCKED.AMOUNT NE VAR.GARNISH.AMT THEN
            TEXT='GARNISH.AMT.NOT.EQUAL'
            CURR.NO=DCOUNT(R.NEW(APAP.GAR.OVERRIDE),@VM) + 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
*END OF MODIFICATION---------------------------------
    END
RETURN
EXIT.SUB:
RETURN TO EXIT.SUB
RETURN
*--------------
END

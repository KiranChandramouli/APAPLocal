* @ValidationCode : MjoxMjA0MDQwODEzOkNwMTI1MjoxNjgxMzY4OTc4MDQ4OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 12:26:18
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.GET.LATEST.OVERDUE.IDS(Y.LOAN.STATUS,Y.LOAN.COND,Y.OVR.IDS)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOFILE.AA.LAON.STATUS.RPT.SPLIT.1
*--------------------------------------------------------------------------------------------------------
*Description       : This is a spilt of the NO-FILE enquiry routine REDO.APAP.NOFILE.AA.LAON.STATUS.RPT
*Linked With       : Enquiry REDO.APAP.NOF.LAON.STATUS.RPT
*In  Parameter     : Y.LOAN.STATUS - Contains the user entered LOAN STATUS
*                    Y.LOAN.COND   - Contains the user entered LOAN CONDITION
*Out Parameter     : Y.OVR.IDS - Contains the list of ARRANGEMENT IDs to be processed
*Files  Used       : AA.OVERDUE              As              I               Mode
*-------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 August 2010       Shiva Prasad Y       ODR-2010-03-0179 136         Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*13-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM , FM to @FM , VM to @VM
*13-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
    FN.AA.ARR.OVERDUE = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE = ''
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    SEL.CMD.OVR = 'SSELECT ':FN.AA.ARR.OVERDUE
    CALL EB.READLIST(SEL.CMD.OVR,SEL.LIST.OVR,'',NO.OF.REC.OVR,SEL.ERR.OVR)

    GOSUB FIND.MULTI.LOCAL.REF

    LOOP
        REMOVE AA.ARR.OVERDUE.ID FROM SEL.LIST.OVR SETTING Y.OVR.POS
    WHILE AA.ARR.OVERDUE.ID : Y.OVR.POS
        AA.ARRANGEMENT.ID = FIELD(AA.ARR.OVERDUE.ID,'-',1)
        LOCATE AA.ARRANGEMENT.ID IN Y.AA.LIST SETTING Y.AA.POS THEN
        END ELSE
            Y.AA.LIST<-1> = AA.ARRANGEMENT.ID
            GOSUB GET.AA.ID
        END
    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------
**********
GET.AA.ID:
**********
    IF Y.LOAN.STATUS AND NOT(Y.LOAN.COND) THEN
        GOSUB CHECK.LOAN.STATUS
    END

    IF NOT(Y.LOAN.STATUS) AND Y.LOAN.COND THEN
        GOSUB CHECK.LOAN.COND
    END

    IF Y.LOAN.STATUS AND Y.LOAN.COND THEN
        GOSUB CHECK.LOAN.STATUS.COND
    END

RETURN

*--------------------------------------------------------------------------------------------------------
******************
CHECK.LOAN.STATUS:
******************
    ARR.ID      = AA.ARRANGEMENT.ID
    EFF.DATE    = TODAY
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG      = ''

    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LN.STATUS = R.CONDITION<AA.OD.LOCAL.REF,LOC.L.LOAN.STATUS.1.POS>
    IF NOT(Y.LN.STATUS) THEN
        RETURN
    END
    CHANGE @SM TO @FM IN Y.LN.STATUS
    CHANGE @VM TO @FM IN Y.LN.STATUS

    LOCATE Y.LOAN.STATUS IN Y.LN.STATUS SETTING Y.STATUS.POS THEN
        Y.OVR.IDS<-1> = AA.ARRANGEMENT.ID
    END

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.LOAN.COND:
****************
    ARR.ID      = AA.ARRANGEMENT.ID
    EFF.DATE    = TODAY
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG      = ''

    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LN.COND = R.CONDITION<AA.OD.LOCAL.REF,LOC.L.LOAN.COND.POS>
    IF NOT(Y.LN.COND) THEN
        RETURN
    END
    CHANGE @SM TO @FM IN Y.LN.COND
    CHANGE @VM TO @FM IN Y.LN.COND

    LOCATE Y.LOAN.COND IN Y.LN.COND SETTING Y.COND.POS THEN
        Y.OVR.IDS<-1> = AA.ARRANGEMENT.ID
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
CHECK.LOAN.STATUS.COND:
***********************
    ARR.ID      = AA.ARRANGEMENT.ID
    EFF.DATE    = TODAY
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG      = ''

    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LN.STATUS = R.CONDITION<AA.OD.LOCAL.REF,LOC.L.LOAN.STATUS.1.POS>
    Y.LN.COND   = R.CONDITION<AA.OD.LOCAL.REF,LOC.L.LOAN.COND.POS>

    IF NOT(Y.LN.STATUS) THEN
        RETURN
    END

    IF NOT(Y.LN.COND) THEN
        RETURN
    END

    CHANGE @SM TO @FM IN Y.LN.STATUS
    CHANGE @VM TO @FM IN Y.LN.STATUS
    CHANGE @SM TO @FM IN Y.LN.COND
    CHANGE @VM TO @FM IN Y.LN.COND

    LOCATE Y.LOAN.STATUS IN Y.LN.STATUS SETTING Y.STAT.POS THEN
        LOCATE Y.LOAN.COND IN Y.LN.COND SETTING Y.COND.POS THEN
            Y.OVR.IDS<-1> = AA.ARRANGEMENT.ID
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'AA.ARR.OVERDUE'
    FLD.ARRAY  = 'L.LOAN.COND':@VM:'L.LOAN.STATUS.1'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.LOAN.COND.POS     = FLD.POS<1,1>
    LOC.L.LOAN.STATUS.1.POS = FLD.POS<1,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Prgram

* @ValidationCode : MjotMTMxNTg1MjQ2NDpDcDEyNTI6MTcwMjk4ODI4MDQ1NTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 17:48:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.BM
SUBROUTINE AB.BUILD.DATA
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*21-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   INSERT FILE MODIFIED , VM to @VM ,FM to@FM,IF STATEMENT MODIFIED
*21-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*13-12-2023       Narmadha V                  Manual R22 Conversion       intialise FN variable,Changed hardcoced value to FN variable, CALL OPF Modified.
*----------------------------------------------------------------------------------------

    
*
* This routine will copy DATA from GLOBUS to the file F.AB.GLOBUS.DATA
* Routine AB.COMPARE.DATA will use this file for comparing GLOBUS data
*
* by ABOU 31.08.1999
*
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION
    $INSERT I_EQUATE
    $INSERT I_F.PGM.FILE
    $INSERT I_F.STANDARD.SELECTION
*
    RTN.ERR = ""
    GOSUB INITIALISE ; IF RTN.ERR THEN
        GOSUB EXIT;* R22 Manual conversion - GOTO changed to GOSUB
    END ;*R22 AUTO CODE CONVERSION
    GOSUB MAIN.PROCESSING ; IF RTN.ERR THEN
        GOSUB EXIT ;* R22 Manual conversion - GOTO changed to GOSUB
    END   ;*R22 AUTO CODE CONVERSION
    PRINT
    PRINT "Process complete"
    PRINT
EXIT:
    IF RTN.ERR THEN
        PRINT RTN.ERR
    END
    PRINT " Press any key ... " ; INPUT GG
*
RETURN
*
*-----------------------------------------------------------------------------
MAIN.PROCESSING:
*-----------------------------------------------------------------------------
*
    MY.AMT.FILES = COUNT ( LIST.OF.FILES, @FM ) + 1
    FOR MY.I = 1 TO MY.AMT.FILES
*CUR.FILE = "F.":LIST.OF.FILES< MY.I >    ;   CRT "*** CUR.FILE *** = ": CUR.FILE
        CUR.FILE = LIST.OF.FILES< MY.I >    ;   CRT "*** CUR.FILE *** = ": CUR.FILE
        CUR.NAME = FIELD(LIST.OF.FILES< MY.I >,'.',2,16)   ; CRT "*** CUR.NAME *** = " : CUR.NAME
        PRINT "Processing ":CUR.FILE
*
        FC.REC = ""
        READ FC.REC FROM F.FILE.CONTROL,CUR.NAME ELSE
            RTN.ERR = " Missing FILE CONTROL record =":CUR.FILE:" Continue [Y/N/''] ? "
            GOSUB ASK.CONTINUE
            IF RTN.ERR EQ "STOP" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END ELSE
                RTN.ERR = ""
                GOSUB NEXT.FILE ;* R22 Manual conversion - GOTO changed to GOSUB
            END
        END
*
        FN.CUR.FILE = "F.CUR.FILE" ;*Manual R22 Convrsion - Intialise variable
        F.CUR.FILE = ""
*CALL OPF ( CUR.FILE, F.CUR.FILE )
        CALL OPF (FN.CUR.FILE, F.CUR.FILE ) ;* Changed format of OPF with Fn varible.
        SS.REC = ""
        CALL GET.STANDARD.SELECTION.DETS(CUR.NAME,SS.REC)
        IF SS.REC EQ "" THEN
            RTN.ERR = " Missing STANDARD SELECTION ":CUR.FILE:" Continue [Y/N/''] ? "
            GOSUB ASK.CONTINUE
            IF RTN.ERR EQ "STOP" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END ELSE
                RTN.ERR = ""
                GOSUB NEXT.FILE;* R22 Manual conversion - GOTO changed to GOSUB
            END
        END
*
        MY.SEL = "SELECT ":CUR.FILE
        SORT.LIST = ""
        SYS.ERROR = ""
        CALL EB.READLIST(MY.SEL,SORT.LIST,'','',SYS.ERROR)
*
        IF SYS.ERROR LT 0 THEN
            RTN.ERR = " Failed select ":CUR.FILE:" Continue [Y/N/''] ? "
            GOSUB ASK.CONTINUE
            IF RTN.ERR EQ "STOP" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END ELSE
                RTN.ERR = ""
                GOSUB NEXT.FILE ;* R22 Manual conversion - GOTO changed to GOSUB
            END
        END
*
        IF SORT.LIST THEN
            COUNT.SORT.LIST = COUNT ( SORT.LIST, @FM ) + 1
            FOR MY.CUR.ID.NUM = 1 TO COUNT.SORT.LIST
                MY.CUR.ID = SORT.LIST < MY.CUR.ID.NUM >
                RTN.ERR = ""
                GOSUB PUT.RECORD.TO.FILE
                IF RTN.ERR NE "" THEN
                    RTN.ERR := " Continue [Y/N/''] ?"
                    GOSUB ASK.CONTINUE
                    IF RTN.ERR EQ "STOP" THEN
                        RTN.ERR = "Break processing !!!"
                        RETURN
                    END ELSE
                        RTN.ERR = ""
                    END
                END
            NEXT MY.CUR.ID.NUM
        END
NEXT.FILE:
    NEXT MY.I
*
    MY.AMT.FILES = COUNT ( LIST.OF.FILES.BPS, @FM ) + 1
    FOR MY.I = 1 TO MY.AMT.FILES
        PRINT "Processing ":LIST.OF.FILES.BPS< MY.I >:" catalog "
        MY.SEL = "SELECT ":LIST.OF.FILES.BPS< MY.I >:" UNLIKE $..."
        SORT.LIST = ""
        SYS.ERROR = ""
        CALL EB.READLIST(MY.SEL,SORT.LIST,'','',SYS.ERROR)
*
        IF SYS.ERROR LT 0 THEN
            RTN.ERR = " Failed select ":LIST.OF.FILES.BPS< MY.I >:" Continue [Y/N/''] ? "
            GOSUB ASK.CONTINUE
            IF RTN.ERR EQ "STOP" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END ELSE
                RTN.ERR = ""
                GOSUB NEXT.FILE.BP ;* R22 Manual conversion - GOTO changed to GOSUB
            END
        END
*
        F.BP = ""
        OPEN LIST.OF.FILES.BPS< MY.I > TO F.BP ELSE
            RTN.ERR = "Can not open ":LIST.OF.FILES.BPS< MY.I >:" catalog Continue [Y/N/''] ? "
            GOSUB ASK.CONTINUE
            IF RTN.ERR EQ "STOP" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END ELSE
                RTN.ERR = ""
                GOSUB NEXT.FILE.BP ;* R22 Manual conversion - GOTO changed to GOSUB
            END
        END
*
        IF SORT.LIST THEN
            COUNT.SORT.LIST = COUNT ( SORT.LIST, @FM ) + 1
            FOR MY.CUR.ID.NUM = 1 TO COUNT.SORT.LIST
                MY.CUR.ID = SORT.LIST < MY.CUR.ID.NUM >
                MY.VAL = ""
                READ MY.VAL FROM F.BP,MY.CUR.ID ELSE
                    RTN.ERR = " Can not read file":MY.CUR.ID:" from ":LIST.OF.FILES.BPS< MY.I >:" Continue [Y/N/''] ? "
                    GOSUB ASK.CONTINUE
                    IF RTN.ERR EQ "STOP" THEN
                        RTN.ERR = "Break processing !!!"
                        RETURN
                    END ELSE
                        RTN.ERR = ""
                        GOSUB NEXT.FILE.BP ;* R22 Manual conversion - GOTO changed to GOSUB
                    END
                END
                IF MY.VAL THEN
                    MY.ID.WRITE = LIST.OF.FILES.BPS< MY.I >:ID.DELIM:MY.CUR.ID
                    RTN.ERR = ""
                    GOSUB WRITE.TO.DISK ; IF RTN.ERR THEN
                        RETURN
                    END ;*R22 AUTO CODE CONVERSION
                END ELSE
                    PRINT "Empty file in ":LIST.OF.FILES.BPS< MY.I >:" ":MY.CUR.ID
                END
            NEXT MY.CUR.ID.NUM
        END
NEXT.FILE.BP:
    NEXT MY.I
*
RETURN
*
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
*
    ID.DELIM = "#%" ;* delimetr of ID's parts
*
    FN.AB.GLOBUS.DATA = "F.AB.GLOBUS.DATA" ;* Manual R22 Conversion - Intialise FN variable
    F.AB.GLOBUS.DATA = ""
*OPEN "F.AB.GLOBUS.DATA" TO F.AB.GLOBUS.DATA ELSE
    OPEN FN.AB.GLOBUS.DATA TO F.AB.GLOBUS.DATA ELSE ;*Manual R22 Conversion- Change hardcoded value to FN variable
        EXECUTE "CREATE.FILE DATA F.AB.GLOBUS.DATA TYPE=J4 10001,1,1"
        F.AB.GLOBUS.DATA = ""
*OPEN "F.AB.GLOBUS.DATA" TO F.AB.GLOBUS.DATA ELSE
        OPEN FN.AB.GLOBUS.DATA TO F.AB.GLOBUS.DATA ELSE  ;*Manual R22 Conversion- Change hardcoded value to FN variable
            RTN.ERR = "Can not open EB.GLOBUS.DATA"
            RETURN
        END
    END
    CLEARFILE F.AB.GLOBUS.DATA
*
    FN.FILE.CONTROL = "F.FILE.CONTROL" ;* Manual R22 Conversion - Intialise FN variable
    F.FILE.CONTROL = ""
* OPEN "F.FILE.CONTROL" TO F.FILE.CONTROL ELSE
    OPEN FN.FILE.CONTROL TO F.FILE.CONTROL ELSE ;*Manual R22 Conversion- Change hardcoded value to FN variable
        RTN.ERR = "Can not open F.FILE.CONTROL"
        RETURN
    END
*
    LIST.OF.FILES = ""
    LIST.OF.FILES.BPS = ""
    RTN.ERR = ""
    GOSUB DEFINE.LIST.OF.FILES ; IF RTN.ERR THEN
        RETURN
    END
    GOSUB DEFINE.LIST.OF.BPS ; IF RTN.ERR THEN
        RETURN
    END ;*R22 AUTO CODE CONVERSION
*
    FL.WRITE.SYSTEM.FLD = ""
*
    LIST.OF.SYSTEM.FIELDS = ""
    LIST.OF.SYSTEM.FIELDS<-1> = "RECORD.STATUS"
    LIST.OF.SYSTEM.FIELDS<-1> = "CURR.NO"
    LIST.OF.SYSTEM.FIELDS<-1> = "INPUTTER"
    LIST.OF.SYSTEM.FIELDS<-1> = "DATE.TIME"
    LIST.OF.SYSTEM.FIELDS<-1> = "AUTHORISER"
    LIST.OF.SYSTEM.FIELDS<-1> = "CO.CODE"
    LIST.OF.SYSTEM.FIELDS<-1> = "DEPT.CODE"
    LIST.OF.SYSTEM.FIELDS<-1> = "AUDITOR.CODE"
    LIST.OF.SYSTEM.FIELDS<-1> = "AUDIT.DATE.TIME"
*
    LIST.OF.SYSTEM.FIELDS<-1> = "LAST.RUN.DATE"
    LIST.OF.SYSTEM.FIELDS<-1> = "NEXT.RUN.DATE"
    LIST.OF.SYSTEM.FIELDS<-1> = "RUN.DATE"
* PD.PARAMETER
    LIST.OF.SYSTEM.FIELDS<-1> = "ACCR.CYCLE.LOCAL"
    LIST.OF.SYSTEM.FIELDS<-1> = "ACCR.CYCLE.FOREIGN"
    LIST.OF.SYSTEM.FIELDS<-1> = "RETRY.FREQ"
* REPORT.CONTROL
    LIST.OF.SYSTEM.FIELDS<-1> = "DATE.LAST.RUN"
    LIST.OF.SYSTEM.FIELDS<-1> = "TIME.LAST.RUN"
    LIST.OF.SYSTEM.FIELDS<-1> = "DATE.LAST.SPOOLED"
    LIST.OF.SYSTEM.FIELDS<-1> = "TIME.LAST.SPOOLED"
*
RETURN
*
*-----------------------------------------------------------------------------
PUT.RECORD.TO.FILE:
*-----------------------------------------------------------------------------
*
    CURR.REC = ""
    M.ERR = ""
    CALL F.READ ( CUR.FILE, MY.CUR.ID, CURR.REC, F.CUR.FILE, M.ERR )
    IF M.ERR NE "" THEN
        RTN.ERR = "Can not read record with ID = ":MY.CUR.ID
        RETURN
    END
*
    MY.AMT.FLD = COUNT ( SS.REC<SSL.SYS.FIELD.NAME> , @VM )
    FOR MY.CUR.FLD = 1 TO MY.AMT.FLD
        MY.FLD = SS.REC < SSL.SYS.FIELD.NAME , MY.CUR.FLD >
        MY.TYPE = SS.REC < SSL.SYS.TYPE , MY.CUR.FLD >
        MY.POS = SS.REC < SSL.SYS.FIELD.NO , MY.CUR.FLD >
        MY.SM = SS.REC < SSL.SYS.SINGLE.MULT , MY.CUR.FLD >
*
        FL.WRITE = "Y"
        IF FL.WRITE.SYSTEM.FLD NE "Y" THEN
            LOCATE MY.FLD IN LIST.OF.SYSTEM.FIELDS<1> SETTING POS ELSE POS = ""
            IF POS THEN
                FL.WRITE = ""
            END
        END
        IF FL.WRITE THEN
            IF MY.TYPE EQ "D" THEN
                MY.VAL = CURR.REC< MY.POS >
                IF TRIM ( MY.VAL, " ", "A" ) NE "" THEN
                    MY.ID.WRITE = CUR.FILE:ID.DELIM:MY.CUR.ID:ID.DELIM:MY.FLD
                    RTN.ERR = ""
                    GOSUB WRITE.TO.DISK ; IF RTN.ERR THEN
                        RETURN
                    END ;*R22 AUTO CODE CONVERSION
                END
            END
        END
    NEXT MY.CUR.FLD
*
RETURN
*
*-----------------------------------------------------------------------------
ASK.CONTINUE:
*-----------------------------------------------------------------------------
*
INPUT.001:
    STOP.RUN = ""
    PRINT RTN.ERR
    INPUT STOP.RUN
    IF STOP.RUN MATCHES "N":@VM:"n" THEN
        RTN.ERR = "STOP"
        RETURN
    END
    IF NOT ( STOP.RUN[1,1] MATCHES "Y":@VM:"y":@VM:"" ) THEN
        GOSUB INPUT.001 ;* R22 Manual conversion - GOTO changed to GOSUB
    END
*
RETURN
*
*-----------------------------------------------------------------------------
WRITE.TO.DISK:
*-----------------------------------------------------------------------------
*
WRITE MY.VAL TO F.AB.GLOBUS.DATA, MY.ID.WRITE ON ERROR RTN.ERR = "Can not write ":MY.ID.WRITE ; RETURN
*
RETURN
*
*-----------------------------------------------------------------------------
DEFINE.LIST.OF.FILES:
*-----------------------------------------------------------------------------
*
    LIST.OF.FILES = ""
    RTN.ERR = ""
*
    LIST.FILES.1 = ""
    F.CONTINUE = "Y"
    LOOP
        PRINT ""
        PRINT "Input name of list [Name or '']?"
        PRINT "- if '' routine will use default list"
        LIST.NAME = ""
        INPUT LIST.NAME
        IF LIST.NAME EQ "" THEN
            F.CONTINUE = ""
        END ELSE
            IF TRIM(LIST.NAME," ","A") MATCHES "Q":@VM:"q" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END
            EXECUTE "GET.LIST ":LIST.NAME
            READLIST LIST.FILES.1 THEN
                F.CONTINUE = ""
            END ELSE
                PRINT "Can not get list ":LIST.NAME
            END
        END
    WHILE F.CONTINUE
    REPEAT
*
    IF LIST.FILES.1 NE "" THEN
        LIST.OF.FILES = LIST.FILES.1
        RETURN
    END
*
RETURN
*
*-----------------------------------------------------------------------------
DEFINE.LIST.OF.BPS:
*-----------------------------------------------------------------------------
*
    LIST.OF.FILES.BPS = ""
    RTN.ERR = ""
*
    LIST.FILES.1 = ""
    F.CONTINUE = "Y"
    LOOP
        PRINT ""
        PRINT "Input name of list for BPs [Name or '']?"
        LIST.NAME = ""
        INPUT LIST.NAME
        IF LIST.NAME EQ "" THEN
            F.CONTINUE = ""
        END ELSE
            IF TRIM(LIST.NAME," ","A") MATCHES "Q":@VM:"q" THEN
                RTN.ERR = "Break processing !!!"
                RETURN
            END
            EXECUTE "GET.LIST ":LIST.NAME
            READLIST LIST.FILES.1 THEN
                F.CONTINUE = ""
            END ELSE
                PRINT "Can not get list ":LIST.NAME
            END
        END
    WHILE F.CONTINUE
    REPEAT
*
    IF LIST.FILES.1 NE "" THEN
        LIST.OF.FILES.BPS = LIST.FILES.1
        RETURN
    END
*
RETURN
*
END
